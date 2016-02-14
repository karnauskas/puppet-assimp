# == Class: assimp
#
# Install assimp library and it's Python bindings
#
# === Examples
#
#  class { 'assimp':
#  }
#
# === Authors
#
# Marius Karnauskas <marius.karnauskas@gmail.com>
#
# === Copyright
#
# Copyright 2016 Marius Karnauskas
#
class assimp {

  include ::assimp::params

  # Library
  if $assimp::params::from_package {
    package { $assimp::params::package_name:
      ensure => $assimp::params::ensure,
    }

  } else {
    $work_dir = $assimp::params::build_dir

    package { $assimp::params::build_deps:
      ensure => $assimp::params::build_deps_ensure,
    } ~>

    archive { 'assimp-build':
      ensure           => present,
      url              => $assimp::params::source,
      target           => $assimp::params::build_dir,
      follow_redirects => true,
      digest_string    => $assimp::params::checksum,
      root_dir         => "assimp-${assimp::params::ensure}",
      strip_components => 1,
    } ~>

    exec { 'assimp-cmake':
      path    => '/usr/bin:/bin',
      cwd     => $work_dir,
      command => "cmake -D 'ASSIMP_BUILD_TESTS=no' CMakeLists.txt -G 'Unix Makefiles'",
      creates => "${work_dir}/Makefile",
    } ~>

    exec { 'assimp-make':
      path    => '/usr/bin:/bin',
      cwd     => $work_dir,
      command => 'make',
    } ~>

    exec { 'assimp-make-install':
      path    => '/usr/bin:/bin',
      cwd     => $work_dir,
      command => 'make install',
      creates => '/usr/local/bin/assimp',
    } ~>

    file { '/etc/ld.so.conf.d/assimp.conf':
      content => template("${module_name}/assimp.conf.erb"),
      notify  => Exec['assimp-ld-reload'],
    }

    exec { 'assimp-ld-reload':
      path        => '/usr/sbin:/sbin',
      command     => 'ldconfig',
      refreshonly => true
    }
  }

  # Python bindings
  if $assimp::params::pybinding_from_package {
    package { $assimp::params::pybinding_package_name:
      ensure => $assimp::params::pybinding_ensure,
    }

  } else {
    package { 'python-pip':
      ensure => 'present',
    } ~>

    python::pip { 'pyassimp':
      ensure => $assimp::params::pybinding_ensure,
    }

  }
}
