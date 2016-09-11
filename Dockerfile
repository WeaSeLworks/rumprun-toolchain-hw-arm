# This container builds the rumprun toolchain for hw/i686
FROM mato/rumprun-buildbase-debian
MAINTAINER Steve Skone <steve@wsl.works>

# All builds are done as non-root.
USER build
WORKDIR /build


RUN DESTDIR=/usr/local && \
    BUILDRUMP_EXTRA="-F ACFLAGS=-march=armv7-a" && \
    CC="/usr/bin/arm-linux-gnueabihf-gcc" && \
    git clone https://github.com/WeaSeLworks/rumprun.git && \
    cd /build/rumprun && \
    git submodule init && git submodule update && \
    sudo apt-get install -y curl && \
    sudo curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | sudo apt-key add - && \
    sudo bash -c "echo 'deb http://emdebian.org/tools/debian/ jessie main' >> /etc/apt/sources.list.d/crosstools.list" && \
    sudo dpkg --add-architecture armhf && \
    sudo apt-get update && \ 
    sudo apt-get install -y crossbuild-essential-armhf 
    
    #./build-rr.sh -d $DESTDIR -o ./obj hw build -- $BUILDRUMP_EXTRA && \
    #sudo ./build-rr.sh -d $DESTDIR -o ./obj hw install && \
    #rm -rf /build/rumprun

# Install a "Hello, World" and build it to verify that the toolchain works.

#COPY hello.c /build/
#RUN i486-rumprun-netbsdelf-gcc -o hello hello.c && \
#    rumprun-bake hw_virtio hello.bin hello && \
#    rm -f hello.bin hello

# Install a welcome script to give the user a hint about what to do next.
# XXX Can't we just update .profile here and run a login shell?
#COPY entrypoint.sh /build/

# XXX Docker Hub fails this with "chmod: changing permissions of '/build/entrypoint.sh: Operation not permitted"
# RUN chmod +x /build/entrypoint.sh
#CMD ["/bin/bash", "/build/entrypoint.sh"]
