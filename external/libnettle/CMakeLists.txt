cmake_minimum_required(VERSION 3.7)

PROJECT("libnettle")

INCLUDE(ExternalProject)


#----------------------------------------------------------------------------
#
# Build the project.
#
MESSAGE("LIBGMP_INCLUDE_DIR: ${LIBGMP_INCLUDE_DIR}")
MESSAGE("LIBGMP_LIBRARY_DIR: ${LIBGMP_LIBRARY_DIR}")

ExternalProject_Add(TARGET_libnettle
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/libnettle
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/nettle-3.9.1.tar.gz
                    URL_HASH SHA1=f129cd7b0c5aa52649957221bb93dd1feef12a2c
                    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "LIBS=-lgmp" ${CMAKE_CURRENT_BINARY_DIR}/libnettle/src/TARGET_libnettle/configure --prefix=${CMAKE_CURRENT_BINARY_DIR}/install --enable-static=yes --enable-shared=no --enable-pic --with-include-path=${LIBGMP_INCLUDE_DIR} --with-lib-path=${LIBGMP_LIBRARY_DIR} --host=${CONFIGURE_HOST}
                    BUILD_COMMAND make
                    INSTALL_COMMAND make install
                    TEST_COMMAND ${CMAKE_CURRENT_SOURCE_DIR}/fix_install_folders.sh ${CMAKE_CURRENT_BINARY_DIR}/install
)

SET(LIBNETTLE_PREFIX       ${CMAKE_CURRENT_BINARY_DIR}/install       CACHE INTERNAL "The complete path to the libnettle installation.")
SET(LIBNETTLE_LIBRARY      ${LIBNETTLE_PREFIX}/lib/libnettle.a       CACHE INTERNAL "The complete path to the libnettle library.")
SET(LIBNETTLE_INCLUDE_DIR  ${LIBNETTLE_PREFIX}/include               CACHE INTERNAL "The include folder for the libnettle library.")
