#! /bin/bash
set -e

#-----------------------------------------------------------------------------
#
# Build all artefacts.
#
pushd build
rm -rf com.github.keplerproject-lua5.1-luasql
rm -rf com.github.keplerproject-lua5.2-luasql
rm -rf com.github.keplerproject-lua5.3-luasql
rm -rf lua5.1
rm -rf lua5.2
rm -rf lua5.3

mkdir com.github.keplerproject-lua5.1-luasql
mkdir com.github.keplerproject-lua5.2-luasql
mkdir com.github.keplerproject-lua5.3-luasql
mkdir -p lua5.1/windows_x86
mkdir -p lua5.1/windows_x86_64
mkdir -p lua5.1/ubuntu_1404_x86
mkdir -p lua5.1/ubuntu_1404_x86_64
mkdir -p lua5.1/ubuntu_1604_x86
mkdir -p lua5.1/ubuntu_1604_x86_64
mkdir -p lua5.1/ubuntu_1610_x86
mkdir -p lua5.1/ubuntu_1610_x86_64
mkdir -p lua5.2/windows_x86
mkdir -p lua5.2/windows_x86_64
mkdir -p lua5.2/ubuntu_1404_x86
mkdir -p lua5.2/ubuntu_1404_x86_64
mkdir -p lua5.2/ubuntu_1604_x86
mkdir -p lua5.2/ubuntu_1604_x86_64
mkdir -p lua5.2/ubuntu_1610_x86
mkdir -p lua5.2/ubuntu_1610_x86_64
mkdir -p lua5.3/windows_x86
mkdir -p lua5.3/windows_x86_64
mkdir -p lua5.3/ubuntu_1404_x86
mkdir -p lua5.3/ubuntu_1404_x86_64
mkdir -p lua5.3/ubuntu_1604_x86
mkdir -p lua5.3/ubuntu_1604_x86_64
mkdir -p lua5.3/ubuntu_1610_x86
mkdir -p lua5.3/ubuntu_1610_x86_64



tar --extract --directory lua5.1/windows_x86 --file build_windows_x86_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/windows_x86 --file build_windows_x86_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/windows_x86 --file build_windows_x86_lua5.3.tar.gz --gzip

tar --extract --directory lua5.1/windows_x86_64 --file build_windows_x86_64_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/windows_x86_64 --file build_windows_x86_64_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/windows_x86_64 --file build_windows_x86_64_lua5.3.tar.gz --gzip

tar --extract --directory lua5.1/ubuntu_1404_x86 --file build_ubuntu_1404_x86_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/ubuntu_1404_x86 --file build_ubuntu_1404_x86_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/ubuntu_1404_x86 --file build_ubuntu_1404_x86_lua5.3.tar.gz --gzip

tar --extract --directory lua5.1/ubuntu_1404_x86_64 --file build_ubuntu_1404_x86_64_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/ubuntu_1404_x86_64 --file build_ubuntu_1404_x86_64_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/ubuntu_1404_x86_64 --file build_ubuntu_1404_x86_64_lua5.3.tar.gz --gzip

tar --extract --directory lua5.1/ubuntu_1604_x86 --file build_ubuntu_1604_x86_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/ubuntu_1604_x86 --file build_ubuntu_1604_x86_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/ubuntu_1604_x86 --file build_ubuntu_1604_x86_lua5.3.tar.gz --gzip

tar --extract --directory lua5.1/ubuntu_1604_x86_64 --file build_ubuntu_1604_x86_64_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/ubuntu_1604_x86_64 --file build_ubuntu_1604_x86_64_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/ubuntu_1604_x86_64 --file build_ubuntu_1604_x86_64_lua5.3.tar.gz --gzip

tar --extract --directory lua5.1/ubuntu_1610_x86 --file build_ubuntu_1610_x86_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/ubuntu_1610_x86 --file build_ubuntu_1610_x86_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/ubuntu_1610_x86 --file build_ubuntu_1610_x86_lua5.3.tar.gz --gzip

tar --extract --directory lua5.1/ubuntu_1610_x86_64 --file build_ubuntu_1610_x86_64_lua5.1.tar.gz --gzip
tar --extract --directory lua5.2/ubuntu_1610_x86_64 --file build_ubuntu_1610_x86_64_lua5.2.tar.gz --gzip
tar --extract --directory lua5.3/ubuntu_1610_x86_64 --file build_ubuntu_1610_x86_64_lua5.3.tar.gz --gzip

popd


pushd build/com.github.keplerproject-lua5.1-luasql
cmake -DCMAKE_INSTALL_PREFIX="" ../../luasql/installer/lua5.1
make
make package
python2.7 ../../cmake/tools/generate_hash.py targets/jonchki/repository/com/github/keplerproject/luasql/*/lua5.1-luasql-*.xml
python2.7 ../../cmake/tools/generate_hash.py targets/jonchki/repository/com/github/keplerproject/luasql/*/lua5.1-luasql-*.tar.xz
popd

pushd build/com.github.keplerproject-lua5.2-luasql
cmake -DCMAKE_INSTALL_PREFIX="" ../../luasql/installer/lua5.2
make
make package
python2.7 ../../cmake/tools/generate_hash.py targets/jonchki/repository/com/github/keplerproject/luasql/*/lua5.2-luasql-*.xml
python2.7 ../../cmake/tools/generate_hash.py targets/jonchki/repository/com/github/keplerproject/luasql/*/lua5.2-luasql-*.tar.xz
popd

pushd build/com.github.keplerproject-lua5.3-luasql
cmake -DCMAKE_INSTALL_PREFIX="" ../../luasql/installer/lua5.3
make
make package
python2.7 ../../cmake/tools/generate_hash.py targets/jonchki/repository/com/github/keplerproject/luasql/*/lua5.3-luasql-*.xml
python2.7 ../../cmake/tools/generate_hash.py targets/jonchki/repository/com/github/keplerproject/luasql/*/lua5.3-luasql-*.tar.xz
popd
