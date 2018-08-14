FROM arvados/jobs:latest
USER root
ARG cores
RUN g
RUN cd / && \
    apt-get update  -y --no-install-recommends --no-install-suggests && \
    apt-get upgrade -y --no-install-recommends --no-install-suggests && \
    apt-get install -y --no-install-recommends --no-install-suggests \
      autoconf \
      automake \
      g++ \
      libqtwebkit-dev \
      libqt5svg5-dev \
      libtool \
      make \
      patch \
      qtbase5-dev \
      wget && \
    echo "deb http://http.debian.net/debian jessie-backports main" | \
      tee --append /etc/apt/sources.list.d/jessie-backports.list > /dev/null && \
    apt-get update && \
    apt-get install -y -t jessie-backports --no-install-suggests --no-install-recommends openjdk-8-jre && \
    git clone -b internal/SiriusAdapter_Cloud https://github.com/oliveralka/OpenMS.git && \
    cd /OpenMS && \
    git submodule init && \
    git submodule update && \
    cd / && \
    mv /OpenMS/THIRDPARTY / && \
    wget https://cmake.org/files/v3.10/cmake-3.10.2-Linux-x86_64.tar.gz  \
      -O cmake.tar.gz  && \
    tar xf cmake.tar.gz && \
    rm cmake.tar.gz && \
    mv cmake* cmake && \
    mkdir /contrib-build && \
    cd /contrib-build && \
    /cmake/bin/cmake -DNUMBER_OF_JOBS=$cores -DBUILD_TYPE=ALL /OpenMS/contrib && \
    rm -rf /OpenMS/contrib && \
    cd / && \
    mkdir /OpenMS-build && \
    rm -rf \
      /contrib-build/archives \
      /contrib-build/src \
      /contrib-build/bin \
      /contrib-build/contrib_build.log \
      /contrib-build/CMakeFiles \
      /contrib-build/cmake_install.cmake \
      /contrib-build/Makefile \
      /contrib-build/README_contrib.txt \
      /contrib-build/CMakeCache.txt  \
      /THIRDPARTY/Windows \
      /THIRDPARTY/MacOS \
      /THIRDPARTY/Linux/32bit && \
    cd /OpenMS-build && \
    env PATH="$(find /THIRDPARTY/ -executable -type f -exec dirname {} \; | sort -u | tr '\n' ':'):${PATH}" \
      /cmake/bin/cmake -DOPENMS_CONTRIB_LIBS=/contrib-build/ /OpenMS && \
    make -j$cores OpenMS TOPP UTILS && \
    apt-get purge -y \
       autoconf \
       automake \
       g++ \
       libtool \
       make \
       patch \
       wget && \
    apt-get --purge -y autoremove && \
    apt-get -y autoclean && \
    apt-get -y clean && \
    rm -rf /tmp/* && \
    rm -rf /OpenMS && \
    rm -rf /var/lib/apt/lists/* && \
    chown -R crunch:crunch /contrib-build && \
    chown -R crunch:crunch /OpenMS-build && \
    chown -R crunch:crunch /THIRDPARTY
USER crunch
