cmake_minimum_required(VERSION 3.7)

PROJECT("libressl")

INCLUDE(ExternalProject)

#----------------------------------------------------------------------------
#
# Build the project.
#
SET(PRJ_CMAKE_ARGS "")

# Do not build the apps.
LIST(APPEND PRJ_CMAKE_ARGS "-DLIBRESSL_APPS=OFF")

# Do not build the tests.
LIST(APPEND PRJ_CMAKE_ARGS "-DLIBRESSL_TESTS=OFF")

# Do not allow ASM code.
LIST(APPEND PRJ_CMAKE_ARGS "-DENABLE_ASM=OFF")

LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")
LIST(APPEND PRJ_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=''")

ExternalProject_Add(TARGET_libressl
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/libressl
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/libressl-3.8.2.tar.gz
                    URL_HASH SHA1=208d7174079bb3be72b12d6d65a4de8360937abb
#                    PATCH_COMMAND "${PYTHON_INTERPRETER}" ${CMAKE_HOME_DIRECTORY}/../cmake/tools/apply_patches.py --working-folder ${CMAKE_CURRENT_BINARY_DIR}/libressl/src/TARGET_libressl --patch-folder ${CMAKE_CURRENT_SOURCE_DIR}/patches --strip 1
                    CMAKE_ARGS ${PRJ_CMAKE_ARGS}
                    INSTALL_COMMAND make install DESTDIR=${CMAKE_CURRENT_BINARY_DIR}/install
)

SET(LIBRESSL_PREFIX       ${CMAKE_CURRENT_BINARY_DIR}/install  CACHE INTERNAL "The complete path to the libressl installation.")
SET(LIBRESSL_LIBRARY_DIR  ${LIBRESSL_PREFIX}/lib               CACHE INTERNAL "The complete path to the libressl library.")
SET(LIBRESSL_INCLUDE_DIR  ${LIBRESSL_PREFIX}/include           CACHE INTERNAL "The include folder for the libressl library.")
