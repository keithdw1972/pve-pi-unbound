export VERSION_OPENSSL=openssl-3.3.2
export SHA256_OPENSSL=2e8a40b01979afe8be0bbfb3de5dc1c6709fedb46d6c89c10da114ab5fc3d281
export SOURCE_OPENSSL=https://www.openssl.org/source/
# OpenSSL OMC
export OPGP_OPENSSL_1=EFC0A467D613CB83C7ED6D30D894E2CE8B3D79F5
# Richard Levitte
export OPGP_OPENSSL_2=7953AC1FBC3DC8B3B292393ED5E9E43F7DF9EE8C
# Matt Caswell
export OPGP_OPENSSL_3=8657ABB260F056B1E5190839D9C4D26D0E604491
# Paul Dale
export OPGP_OPENSSL_4=B7C1C14360F353A36862E4D5231C84CDDCC69C45
# Tomas Mraz
export OPGP_OPENSSL_5=A21FAB74B0088AA361152586B8EF1A6BA9DA2D5C
# Tim Hudson
export OPGP_OPENSSL_6=C1F33DD8CE1D4CC613AF14DA9195C48241FBF7DD
# Kurt Roeckx
export OPGP_OPENSSL_7=E5E52560DD91C556DDBDA5D02064C53641C25E5D
# OpenSSL
export OPGP_OPENSSL_8=BA5473A2B0587B07FB27CF2D216094DFD0CB81EF

set -e -x
mkdir /tmp/src
cd /tmp/src
build_deps="build-essential ca-certificates curl dirmngr gnupg libidn2-0-dev libssl-dev"
apt-get update && apt-get install -y --no-install-recommends $build_deps
curl -L $SOURCE_OPENSSL$VERSION_OPENSSL.tar.gz -o openssl.tar.gz
echo "${SHA256_OPENSSL} ./openssl.tar.gz" | sha256sum -c -
curl -L $SOURCE_OPENSSL$VERSION_OPENSSL.tar.gz.asc -o openssl.tar.gz.asc
GNUPGHOME="$(mktemp -d)"
export GNUPGHOME
gpg --no-tty --keyserver keyserver.ubuntu.com --recv-keys "$OPGP_OPENSSL_1" "$OPGP_OPENSSL_2" "$OPGP_OPENSSL_3" "$OPGP_OPENSSL_4" "$OPGP_OPENSSL_5" "$OPGP_OPENSSL_6" "$OPGP_OPENSSL_7" "$OPGP_OPENSSL_8"
gpg --batch --verify openssl.tar.gz.asc openssl.tar.gz
tar xzf openssl.tar.gz
cd $VERSION_OPENSSL
./config --prefix=/opt/openssl --openssldir=/opt/openssl no-weak-ssl-ciphers no-ssl3 no-shared enable-ec_nistp_64_gcc_128 -DOPENSSL_NO_HEARTBEATS -fstack-protector-strong
make depend
nproc | xargs -I % make -j%
make install_sw
apt-get purge -y --auto-remove $build_deps
rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists/*
