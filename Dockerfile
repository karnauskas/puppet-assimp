FROM fedora:22
RUN dnf install -y rubygems rubygem-bundler ruby-devel python-pip make cmake minizip-devel libffi-devel
ADD . /assimp/
WORKDIR /assimp
RUN bundle install
CMD /bin/bash
