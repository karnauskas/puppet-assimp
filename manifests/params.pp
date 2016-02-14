# == Class: assimp::params
#
# Default parameters
#
class assimp::params {
  $from_package = false
  $ensure = '3.2'
  $source = 'https://github.com/assimp/assimp/archive/v3.2.tar.gz'
  $checksum = 'bb0cfa1513c4e11cf7ba14ba66548072'

  $package_name = 'assimp'

  $build_deps = $::osfamily ? {
      'RedHat' => ['gcc-c++', 'cmake', 'make', 'minizip-devel', 'zlib-devel'],
      'Debian' => ['cpp', 'cmake', 'make', 'libzip-dev', 'libzzip-dev'],
      default => ['cmake', 'make']
  }

  $build_deps_ensure = 'present'
  $build_dir = '/tmp/assimp-build'

  $pybinding_from_package = false
  $pybinding_ensure = '0.1'
  $pybinding_package_name = 'python-pyassimp'
}
