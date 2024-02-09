cmake_minimum_required(VERSION 3.5)

PROJECT("luasql")

INCLUDE(ExternalProject)
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)

SET(VERSION_EXTERNAL "2.6.0")
SET(VERSION_PACKAGE  "4")
SET(PROJECT_VERSION  "${VERSION_EXTERNAL}.${VERSION_PACKAGE}")

# Get the VCS version for the jonchki configuration.
INCLUDE(${CMAKE_HOME_DIRECTORY}/cmake/version.cmake)

# Filter the jonchki configuration.
CONFIGURE_FILE(mysql/installer/lua${BUILDCFG_LUA_VERSION}/luasql-mysql.xml
               ${CMAKE_BINARY_DIR}/lua${BUILDCFG_LUA_VERSION}-luasql-mysql-${PROJECT_VERSION}.xml
               @ONLY)
CONFIGURE_FILE(postgres/installer/lua${BUILDCFG_LUA_VERSION}/luasql-postgres.xml
               ${CMAKE_BINARY_DIR}/lua${BUILDCFG_LUA_VERSION}-luasql-postgres-${PROJECT_VERSION}.xml
               @ONLY)
CONFIGURE_FILE(sqlite3/installer/lua${BUILDCFG_LUA_VERSION}/luasql-sqlite3.xml
               ${CMAKE_BINARY_DIR}/lua${BUILDCFG_LUA_VERSION}-luasql-sqlite3-${PROJECT_VERSION}.xml
               @ONLY)

#----------------------------------------------------------------------------
#
# Build the project.
#

IF((${BUILDCFG_ONLY_JONCHKI_CFG} STREQUAL "OFF"))
	# Select the LUA version.
	INCLUDE(${CMAKE_HOME_DIRECTORY}/cmake/muhkuh_lua.cmake)

	SET(SUB_CMAKE_ARGS "")
	LIST(APPEND SUB_CMAKE_ARGS "-DCMAKE_TOOLCHAIN_FILE=${CMAKE_TOOLCHAIN_FILE}")

	LIST(APPEND SUB_CMAKE_ARGS "-DLUASQL_VERSION_NUMBER=${VERSION_EXTERNAL}")
	LIST(APPEND SUB_CMAKE_ARGS "-DLUA_INCLUDE_DIR=${LUA_INCLUDE_DIR}")
	LIST(APPEND SUB_CMAKE_ARGS "-DLUA_LIBRARIES=${LUA_LIBRARIES}")

	LIST(APPEND SUB_CMAKE_ARGS "-DSQLITE_LIB=${EXTERNAL_LIB_DIR}/libsqlite3.a")
	LIST(APPEND SUB_CMAKE_ARGS "-DSQLITE_INCLUDE_DIR=${EXTERNAL_INCLUDE_DIR}")

	LIST(APPEND SUB_CMAKE_ARGS "-DMARIADB_LIB=${EXTERNAL_LIB_DIR}/mariadb/libmariadbclient.a")
	LIST(APPEND SUB_CMAKE_ARGS "-DMARIADB_INCLUDE_DIR=${EXTERNAL_INCLUDE_DIR}/mariadb")

	LIST(APPEND SUB_CMAKE_ARGS "-DGNUTLS_LIBRARY=${CMAKE_BINARY_DIR}/../../external/gnutls/install/lib/libgnutls.a")
	LIST(APPEND SUB_CMAKE_ARGS "-DHOGWEED_LIBRARY=${CMAKE_BINARY_DIR}/../../external/libnettle/install/lib/libhogweed.a")
	LIST(APPEND SUB_CMAKE_ARGS "-DNETTLE_LIBRARY=${CMAKE_BINARY_DIR}/../../external/libnettle/install/lib/libnettle.a")
	LIST(APPEND SUB_CMAKE_ARGS "-DGMP_LIBRARY=${CMAKE_BINARY_DIR}/../../external/gmp/install/lib/libgmp.a")

	LIST(APPEND SUB_CMAKE_ARGS "-DPQ_INCLUDE_DIR1=${CMAKE_BINARY_DIR}/../../external/libpq/install/include")
	LIST(APPEND SUB_CMAKE_ARGS "-DPQ_INCLUDE_DIR2=${CMAKE_BINARY_DIR}/../../external/libpq/postgresql/src/TARGET_libpq/src/include")
	LIST(APPEND SUB_CMAKE_ARGS "-DPQ_INCLUDE_DIR3=${CMAKE_BINARY_DIR}/../../external/libpq/postgresql/src/TARGET_libpq-build/src/include")
	LIST(APPEND SUB_CMAKE_ARGS "-DPQ_LIBRARY1=${CMAKE_BINARY_DIR}/../../external/libpq/install/lib/libpq.a")
	LIST(APPEND SUB_CMAKE_ARGS "-DPQ_LIBRARY2=${CMAKE_BINARY_DIR}/../../external/libpq/postgresql/src/TARGET_libpq-build/src/common/libpgcommon.a")
	LIST(APPEND SUB_CMAKE_ARGS "-DPQ_LIBRARY3=${CMAKE_BINARY_DIR}/../../external/libpq/postgresql/src/TARGET_libpq-build/src/port/libpgport.a")

	LIST(APPEND SUB_CMAKE_ARGS "-DTEST_SCRIPT_FOLDER=${CMAKE_HOME_DIRECTORY}/cmake/tests")
	LIST(APPEND SUB_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=${CMAKE_CURRENT_BINARY_DIR}/install")
	LIST(APPEND SUB_CMAKE_ARGS "-DINSTALL_DIR_LUA_MODULES=${INSTALL_DIR_LUA_MODULES}")

	ExternalProject_Add(TARGET_luasql
	                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/luasql-${VERSION_EXTERNAL}
	                    URL ${CMAKE_CURRENT_SOURCE_DIR}/luasql-${VERSION_EXTERNAL}.tar.gz
	                    URL_HASH SHA1=cd419e4ce96ee89944e50939f756ec9b64dbae45
	                    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/copy_over ${CMAKE_CURRENT_BINARY_DIR}/luasql-${VERSION_EXTERNAL}/src/TARGET_luasql
	                    CMAKE_ARGS ${SUB_CMAKE_ARGS}
	                    TEST_BEFORE_INSTALL 1
	                    TEST_COMMAND pwd && ${CMAKE_MAKE_PROGRAM} test
	                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
	)

	#----------------------------------------------------------------------------
	#
	# Build the selected driver package.
	#

	IF((${BUILDCFG_DRIVER} STREQUAL "mysql"))
		ADD_SUBDIRECTORY(mysql)
	ELSEIF((${BUILDCFG_DRIVER} STREQUAL "postgres"))
		ADD_SUBDIRECTORY(postgres)
	ELSEIF((${BUILDCFG_DRIVER} STREQUAL "sqlite3"))
		ADD_SUBDIRECTORY(sqlite3)
	ENDIF((${BUILDCFG_DRIVER} STREQUAL "mysql"))
ENDIF((${BUILDCFG_ONLY_JONCHKI_CFG} STREQUAL "OFF"))
