cmake_minimum_required(VERSION 2.8)

PROJECT("mysql")

INCLUDE(ExternalProject)


SET(VERSION_EXTERNAL "5.7.15")

#----------------------------------------------------------------------------
#
# The MySQL build process needs some tools which are generated during the
# build itself. This is problematic for cross-compiling.
#
# Build a native version first if we are cross-compiling.
#
MESSAGE(STATUS "Cross compiling: ${CMAKE_CROSSCOMPILING}.")
IF(${CMAKE_CROSSCOMPILING})
	MESSAGE(STATUS "Building a native version of MySQL.")

	SET(MYSQL_NATIVE_CMAKE_ARGS "")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_BOOST=${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/src/TARGET_mysql_native/boost")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DDISABLE_SHARED=ON")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITHOUT_SERVER=ON")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_VALGRIND=OFF")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_MSCRT_DEBUG=OFF")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DENABLE_GCOV=OFF")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DENABLE_GPROF=OFF")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_CLIENT_PROTOCOL_TRACING=OFF")

	ExternalProject_Add(TARGET_mysql_native
	                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}
	                    URL ${CMAKE_CURRENT_SOURCE_DIR}/mysql-boost-${VERSION_EXTERNAL}.tar.gz
	                    URL_HASH SHA1=3113a720003b7519ddd040e82fb7c0b918cf759d
	                    CMAKE_ARGS ${MYSQL_NATIVE_CMAKE_ARGS}
	                    INSTALL_COMMAND ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/src/TARGET_mysql_native-build/extra/comp_err ${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/tools/
	)
ENDIF(${CMAKE_CROSSCOMPILING})



#----------------------------------------------------------------------------
#
# Build the project for the target architecture.
#
#SET(MYSQL_CMAKE_ARGS "")
#LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
#LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
#LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
#LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
#IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
#	LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_RC_COMPILER=${CMAKE_RC_COMPILER}")
#ELSE(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
#	LIST(APPEND MYSQL_CMAKE_ARGS "-DSTACK_DIRECTION=1")
#ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
#
#ExternalProject_Add(TARGET_mysql
#                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/libmysqlclient-${VERSION_EXTERNAL}
#                    URL ${CMAKE_CURRENT_SOURCE_DIR}/mysql-boost-${VERSION_EXTERNAL}.tar.gz
#                    URL_HASH SHA1=3113a720003b7519ddd040e82fb7c0b918cf759d
#                    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/copy_over ${CMAKE_CURRENT_BINARY_DIR}/libmysqlclient-${VERSION_EXTERNAL}/src/TARGET_libmysqlclient
#                    CMAKE_ARGS ${MYSQL_CMAKE_ARGS}
#                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install DESTDIR=${CMAKE_CURRENT_BINARY_DIR}/libmysqlclient-${VERSION_EXTERNAL}
#)



# 3) Provide all variables for the build.
SET(LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/libmysqlclient-${VERSION_EXTERNAL}/install/lib/libmysqlclient.a)

#IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU"  AND  "${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
#	SET(LDFLAGS "")
#ENDIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU"  AND  "${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")

SET(INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR}/libmysqlclient-${VERSION_EXTERNAL}/install/include)

#----------------------------------------------------------------------------
#
# Store all information about the library in the cache.
#
SET(LIBMYSQLCLIENT_LIBRARY              ${LIBRARY}              CACHE INTERNAL "The libmysqlclient library with the complete path.")
#SET(LIBMYSQLCLIENT_LDFLAGS              ${LDFLAGS}              CACHE INTERNAL "All linker flags required to link the library. The list must be separated with whitespace.")
#SET(LIBMYSQLCLIENT_DEFINES              ${DEFINES}              CACHE INTERNAL "All defines for the libusb library. This should be a list of entries starting with -D.")
SET(LIBMYSQLCLIENT_INCLUDE_DIRECTORIES  ${INCLUDE_DIRECTORIES}  CACHE INTERNAL "The include folders for the library headers. The list must be separated with whitespace.")
