cmake_minimum_required(VERSION 3.2.3)

PROJECT("mariadb-connector-c")

INCLUDE(ExternalProject)

# Python is used for some test scripts.
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)


#----------------------------------------------------------------------------
#
# Build the project.
#
SET(PRJ_CMAKE_ARGS "")

LIST(APPEND PRJ_CMAKE_ARGS "-DWITH_MYSQLCOMPAT=ON")
LIST(APPEND PRJ_CMAKE_ARGS "-DWITH_UNIT_TESTS=OFF")
LIST(APPEND PRJ_CMAKE_ARGS "-DWITH_CURL=OFF")
LIST(APPEND PRJ_CMAKE_ARGS "-DWITH_SSL=OPENSSL")
LIST(APPEND PRJ_CMAKE_ARGS "-DOPENSSL_ROOT_DIR=${CMAKE_BINARY_DIR}/openssl/install/usr/local")
LIST(APPEND PRJ_CMAKE_ARGS "-DOPENSSL_USE_STATIC_LIBS=TRUE")
LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=''")

ExternalProject_Add(TARGET_mariadbconnector
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/mariadbconnector
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/mariadb-connector-c-3.1.3-src.tar.gz
                    URL_HASH SHA1=65ce74f06b89432d99e7269675957c908d6c1e4c
                    PATCH_COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/apply_patches.py --working-folder ${CMAKE_CURRENT_BINARY_DIR}/mariadbconnector/src/TARGET_mariadbconnector --patch-folder ${CMAKE_CURRENT_SOURCE_DIR}/patches --strip 1 --copy-folder ${CMAKE_CURRENT_SOURCE_DIR}/copy
                    CMAKE_ARGS ${PRJ_CMAKE_ARGS}
                    INSTALL_COMMAND make install DESTDIR=${CMAKE_BINARY_DIR}/install
)
