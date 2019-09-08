cmake_minimum_required(VERSION 2.8)

PROJECT("mysql")

INCLUDE(ExternalProject)

# Python is used for the patch tool.
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)

SET(VERSION_EXTERNAL "8.0.17")


65ce74f06b89432d99e7269675957c908d6c1e4c  mariadb-connector-c-3.1.3-src.tar.gz

#----------------------------------------------------------------------------
#
# The MySQL build process needs some tools which are generated during the
# build itself. This is problematic for cross-compiling.
#
# Build a native version first if we are cross-compiling.
#
IF(${CMAKE_CROSSCOMPILING})
	MESSAGE(STATUS "Cross compiling -> building a native version of MySQL to get the tools.")

	SET(MYSQL_NATIVE_CMAKE_ARGS "")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_BOOST=${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/src/TARGET_mysql_native/boost")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DDISABLE_SHARED=ON")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITHOUT_SERVER=ON")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_VALGRIND=OFF")
	IF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
		LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_MSCRT_DEBUG=OFF")
	ENDIF(${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DENABLE_GCOV=OFF")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DENABLE_GPROF=OFF")
	LIST(APPEND MYSQL_NATIVE_CMAKE_ARGS "-DWITH_CLIENT_PROTOCOL_TRACING=OFF")

	ExternalProject_Add(TARGET_mysql_native
	                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}
	                    URL ${CMAKE_CURRENT_SOURCE_DIR}/mysql-boost-${VERSION_EXTERNAL}.tar.gz
	                    URL_HASH SHA1=8395df42d93e2030fcef862bb096831b24ed5c28
	                    CMAKE_ARGS ${MYSQL_NATIVE_CMAKE_ARGS}
	                    INSTALL_COMMAND ${CMAKE_COMMAND} -E make_directory ${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/install && ${CMAKE_COMMAND} -E copy ${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/src/TARGET_mysql_native-build/extra/comp_err ${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/install/
	)

	SET(MYSQL_DEPENDS TARGET_mysql_native)
ELSE(${CMAKE_CROSSCOMPILING})
	SET(MYSQL_DEPENDS )
ENDIF(${CMAKE_CROSSCOMPILING})



#----------------------------------------------------------------------------
#
# Build the project for the target architecture.
#
SET(MYSQL_CMAKE_ARGS "")
LIST(APPEND MYSQL_CMAKE_ARGS "-DWITH_BOOST=${CMAKE_CURRENT_BINARY_DIR}/mysql-${VERSION_EXTERNAL}/src/TARGET_mysql/boost")
LIST(APPEND MYSQL_CMAKE_ARGS "-DDISABLE_SHARED=ON")
LIST(APPEND MYSQL_CMAKE_ARGS "-DWITHOUT_SERVER=ON")
LIST(APPEND MYSQL_CMAKE_ARGS "-DWITH_VALGRIND=OFF")
LIST(APPEND MYSQL_CMAKE_ARGS "-DWITH_MSCRT_DEBUG=OFF")
LIST(APPEND MYSQL_CMAKE_ARGS "-DENABLE_GCOV=OFF")
LIST(APPEND MYSQL_CMAKE_ARGS "-DENABLE_GPROF=OFF")
LIST(APPEND MYSQL_CMAKE_ARGS "-DWITH_CLIENT_PROTOCOL_TRACING=OFF")
LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=install")
LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
# NOTE: Do not change the system name if this is a local build. Otherwise
# CMake thinks it is cross compiling and will not run certain checks.
IF(${CMAKE_CROSSCOMPILING})
	LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
ENDIF(${CMAKE_CROSSCOMPILING})
LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	LIST(APPEND MYSQL_CMAKE_ARGS "-DCMAKE_RC_COMPILER=${CMAKE_RC_COMPILER}")
ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
IF(${CMAKE_CROSSCOMPILING})
	# Use the "comp_err" tool from the native build.
	LIST(APPEND MYSQL_CMAKE_ARGS "-DCOMP_ERR_PATH=${CMAKE_CURRENT_BINARY_DIR}/mysql-native-${VERSION_EXTERNAL}/install/comp_err")
ELSE(${CMAKE_CROSSCOMPILING})
	# NOTE: Set the COMP_ERR_PATH option to the default value as it can not use it in the ADD_CUSTOM_COMMAND properly.
	LIST(APPEND MYSQL_CMAKE_ARGS "-DCOMP_ERR_PATH=comp_err")
ENDIF(${CMAKE_CROSSCOMPILING})

# Unix platforms need PIC.
IF(UNIX)
	LIST(APPEND MYSQL_CMAKE_ARGS "-DWITH_PIC=ON")
ENDIF(UNIX)

ExternalProject_Add(TARGET_mysql
                    DEPENDS ${MYSQL_DEPENDS}
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/mysql-${VERSION_EXTERNAL}
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/mysql-boost-${VERSION_EXTERNAL}.tar.gz
                    URL_HASH SHA1=8395df42d93e2030fcef862bb096831b24ed5c28
                    PATCH_COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/apply_patches.py --working-folder ${CMAKE_CURRENT_BINARY_DIR}/mysql-${VERSION_EXTERNAL}/src/TARGET_mysql --patch-folder ${CMAKE_CURRENT_SOURCE_DIR}/patches --strip 1
                    CMAKE_ARGS ${MYSQL_CMAKE_ARGS}
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
)


# Install all components to the common folder.
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/mysql-${VERSION_EXTERNAL}/src/TARGET_mysql-build/install/lib/libmysqlclient.a
        DESTINATION ${CMAKE_BINARY_DIR}/install/lib/)
INSTALL(DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/mysql-${VERSION_EXTERNAL}/src/TARGET_mysql-build/install/include
        DESTINATION ${CMAKE_BINARY_DIR}/install)
