#! /bin/bash
set -e

# Get the full path to the source archive.
MYSQL_TAR=${PWD}/mysql-boost-5.7.15.tar.gz

# Get the extracted folder name.
MYSQL_FOLDER=mysql-5.7.15

# Get the full path to additional folders.
PATH_MINGW32=/usr/mingw-w64-i686/bin
PATH_MINGW64=/usr/mingw-w64-x86_64/bin
PATH_TOOLS=${PWD}/tools

# Get the full path to all patches.
PATCH_FOLDER=${PWD}/patches

# Remove the old build folder.
rm -rf build

# Create a new build folder and extract the source archive.
echo "Extracting source archive..."
mkdir build
pushd build
tar --extract --file ${MYSQL_TAR} --gunzip
popd

# Patch the sources.
echo "Patching the sources..."
pushd build/${MYSQL_FOLDER}
for PATCHFILE in `find ${PATCH_FOLDER} -name "*.diff" | sort`; do
	echo "Applying patchfile $PATCHFILE..."
	patch -p1 <$PATCHFILE
done
popd

# Build the sources.
echo "build the sources..."
mkdir build/${MYSQL_FOLDER}/build_native
pushd build/${MYSQL_FOLDER}/build_native
# This is a workaround for the comp_err tool, which does not create more than one folder (i.e. no "mkdir -p" functionality).
mkdir -p sql/share
PATH=${PATH}:${PATH_MINGW32}:${PATH_MINGW64}:${PATH_TOOLS} cmake -DWITH_BOOST=`realpath ../boost` -DDISABLE_SHARED=ON -DWITHOUT_SERVER=ON -DWITH_VALGRIND=OFF -DWITH_MSCRT_DEBUG=OFF -DENABLE_GCOV=OFF -DENABLE_GPROF=OFF -DWITH_CLIENT_PROTOCOL_TRACING=OFF -DCMAKE_C_FLAGS=-m32 -DCMAKE_CXX_FLAGS=-m32 -DCMAKE_SYSTEM_NAME=Windows -DCMAKE_C_COMPILER=i686-w64-mingw32-gcc -DCMAKE_CXX_COMPILER=i686-w64-mingw32-g++ -DCMAKE_RC_COMPILER=i686-w64-mingw32-windres ..
PATH=${PATH}:${PATH_MINGW32}:${PATH_MINGW64}:${PATH_TOOLS} make
popd

