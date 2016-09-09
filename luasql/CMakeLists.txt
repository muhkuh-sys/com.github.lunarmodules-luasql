cmake_minimum_required(VERSION 2.8)

PROJECT("luasql")

INCLUDE(ExternalProject)


SET(VERSION_EXTERNAL "2.3.2")

#----------------------------------------------------------------------------
#
# Build the project.
#
SET(SUB_CMAKE_ARGS "")
LIST(APPEND SUB_CMAKE_ARGS "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
LIST(APPEND SUB_CMAKE_ARGS "-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
LIST(APPEND SUB_CMAKE_ARGS "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
LIST(APPEND SUB_CMAKE_ARGS "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	LIST(APPEND SUB_CMAKE_ARGS "-DCMAKE_RC_COMPILER=${CMAKE_RC_COMPILER}")
ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

ExternalProject_Add(TARGET_luasql
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/luasql-${VERSION_EXTERNAL}
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/luasql-${VERSION_EXTERNAL}.tar.gz
                    URL_HASH SHA1=089b797d22589277b9b2f926f4da008fe7026ccb
                    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/copy_over ${CMAKE_CURRENT_BINARY_DIR}/luasql-${VERSION_EXTERNAL}/src/TARGET_luasql
                    CMAKE_ARGS ${SUB_CMAKE_ARGS}
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${CMAKE_CURRENT_BINARY_DIR}/luasql-${VERSION_EXTERNAL}
)



SET(PLUGIN ${CMAKE_CURRENT_BINARY_DIR}/luasql-${VERSION_EXTERNAL}/install/lib/luasql.so)

#----------------------------------------------------------------------------
#
# Store all information about the library in the cache.
#
SET(LUASQL_PLUGIN              ${PLUGIN}              CACHE INTERNAL "The libmysqlclient library with the complete path.")
