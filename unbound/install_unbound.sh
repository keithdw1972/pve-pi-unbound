export NAME=unbound
export UNBOUND_VERSION=1.22.0
export UNBOUND_SHA256=c5dd1bdef5d5685b2cedb749158dd152c52d44f65529a34ac15cd88d4b1b3d43
export UNBOUND_DOWNLOAD_URL=https://nlnetlabs.nl/downloads/unbound/unbound-1.22.0.tar.gz

set -e -x
build_deps="curl gcc libc-dev libevent-dev libexpat1-dev libnghttp2-dev make"
apt-get update && apt-get install -y --no-install-recommends $build_deps bsdmainutils ca-certificates ldnsutils libevent-2.1-7 libexpat1 libprotobuf-c-dev protobuf-c-compiler
curl -sSL $UNBOUND_DOWNLOAD_URL -o unbound.tar.gz
echo "${UNBOUND_SHA256} *unbound.tar.gz" | sha256sum -c -
tar xzf unbound.tar.gz
rm -f unbound.tar.gz
cd unbound-1.22.0
groupadd _unbound
useradd -g _unbound -s /dev/null -d /etc _unbound
./configure --disable-dependency-tracking --prefix=/opt/unbound --with-pthreads --with-username=_unbound --with-ssl=/opt/openssl --with-libevent --with-libnghttp2 --enable-dnstap --enable-tfo-server --enable->make install
mv /opt/unbound/etc/unbound/unbound.conf /opt/unbound/etc/unbound/unbound.conf.example
apt-get purge -y --auto-remove $build_deps
rm -rf /opt/unbound/share/man /tmp/* /var/tmp/* /var/lib/apt/lists/*

export PATH=/opt/unbound/sbin:"$PATH"
