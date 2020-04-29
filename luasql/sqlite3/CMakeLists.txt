cmake_minimum_required(VERSION 3.5)

PROJECT("luasql-sqlite3")
SET(PROJECT_VERSION  "${VERSION_EXTERNAL}.${VERSION_PACKAGE}")

#----------------------------------------------------------------------------
#
# Build a package for the selected platform.
#

SET(CPACK_OUTPUT_FILE_PREFIX ${CMAKE_BINARY_DIR}/../../../repository/com/github/keplerproject/luasql/${PROJECT_VERSION})
SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
SET(CPACK_PACKAGE_FILE_NAME "lua${BUILDCFG_LUA_VERSION}-luasql-sqlite3-${PROJECT_VERSION}-${JONCHKI_PLATFORM}")

SET(CPACK_GENERATOR "TXZ")
INCLUDE(CPack)

# This is the folder where the external project TARGET_luasql installed the files.
SET(SUB_INSTALL_DIR "${CMAKE_CURRENT_BINARY_DIR}/../install/lua_plugins")

IF(${JONCHKI_PLATFORM_DIST_ID} STREQUAL "windows")
	# Package a windows build.

	INSTALL(FILES ${SUB_INSTALL_DIR}/luasql/sqlite3.dll
	        DESTINATION lua_plugins)

	CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/install_windows.lua
	               ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
	               @ONLY)

	INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
	        DESTINATION .)
ELSE(${JONCHKI_PLATFORM_DIST_ID} STREQUAL "windows")
	# Package a linux build.

	INSTALL(FILES ${SUB_INSTALL_DIR}/luasql/sqlite3.so
	        DESTINATION lua_plugins)

	CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/install_linux.lua
	               ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
	               @ONLY)

	INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/package/install.lua
	        DESTINATION .)
ENDIF(${JONCHKI_PLATFORM_DIST_ID} STREQUAL "windows")

CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/luasql-sqlite3.xml
               ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasql-sqlite3-${PROJECT_VERSION}-${JONCHKI_PLATFORM}.xml
               @ONLY)


#-----------------------------------------------------------------------------
#
# Create a custom target named "pack".
# It builds the package and creates the hashes.
#
ADD_CUSTOM_TARGET(pack
                  COMMAND ${CMAKE_MAKE_PROGRAM}
                  COMMAND ${CMAKE_MAKE_PROGRAM} package
                  COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/generate_hash.py ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasql-sqlite3-${PROJECT_VERSION}-${JONCHKI_PLATFORM}.xml
                  COMMAND "${PYTHON_EXECUTABLE}" ${CMAKE_HOME_DIRECTORY}/cmake/tools/generate_hash.py ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasql-sqlite3-${PROJECT_VERSION}-${JONCHKI_PLATFORM}.tar.xz
                  COMMENT "Pack the artifact and generate the hashes...")


#-----------------------------------------------------------------------------
#
# Filter the pom.xml file.
#
SET(POM_ARTIFACT_ID  "luasql-sqlite3")
SET(POM_GROUP_ID     "com.github.keplerproject")
SET(POM_VERSION      "${PROJECT_VERSION}")
SET(POM_PACKAGING    "tar.xz")
CONFIGURE_FILE(installer/lua${BUILDCFG_LUA_VERSION}/pom.xml
               ${CPACK_OUTPUT_FILE_PREFIX}/lua${BUILDCFG_LUA_VERSION}-luasql-sqlite3-${PROJECT_VERSION}.pom
               @ONLY)
