cmake_minimum_required(VERSION 3.7)

PROJECT("libpq")

INCLUDE(ExternalProject)

# Python is used for the patch script.
#FIND_PACKAGE(PythonInterp 2.7 REQUIRED)

#----------------------------------------------------------------------------
#
# Build the project.
#
MESSAGE("CONFIGURE_HOST: ${CONFIGURE_HOST}")
ExternalProject_Add(TARGET_libpq
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/postgresql
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/postgresql-16.2.tar.bz2
                    URL_HASH SHA1=fc3d0e598410bbdf59f240821c9c77a6936467b6
                    PATCH_COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/apply_patches.py --working-folder ${CMAKE_CURRENT_BINARY_DIR}/postgresql/src/TARGET_libpq --patch-folder ${CMAKE_CURRENT_SOURCE_DIR}/patches --strip 1
                    CONFIGURE_COMMAND ${CMAKE_COMMAND} -E env "CFLAGS=-fPIC" "CPPFLAGS=-fPIC -I${CMAKE_BINARY_DIR}/../lua5.4/build_requirements/jonchki/install/dev/include -I${LIBRESSL_INCLUDE_DIR}" "LDFLAGS=-L${CMAKE_BINARY_DIR}/../lua5.4/build_requirements/jonchki/install/dev/lib -L${LIBRESSL_LIBRARY_DIR}" ${CMAKE_CURRENT_BINARY_DIR}/postgresql/src/TARGET_libpq/configure --prefix=${CMAKE_CURRENT_BINARY_DIR}/install --without-icu --without-readline --with-ssl=openssl --host=${CONFIGURE_HOST}
                    BUILD_COMMAND ${CMAKE_COMMAND} -E env --unset=MAKEFLAGS --unset=MAKELEVEL make -C src/interfaces/libpq
                    INSTALL_COMMAND ${CMAKE_COMMAND} -E env --unset=MAKEFLAGS --unset=MAKELEVEL make -C src/interfaces/libpq install
)


SET(LIBPQ_PREFIX       ${CMAKE_CURRENT_BINARY_DIR}/install    CACHE INTERNAL "The complete path to the libpq installation.")
SET(LIBPQ_LIBRARY      ${LIBPQ_PREFIX}/lib/libpq.a            CACHE INTERNAL "The complete path to the libpq library.")
SET(LIBPQ_INCLUDE_DIR  ${LIBPQ_PREFIX}/include                CACHE INTERNAL "The include folder for the libpq library.")
