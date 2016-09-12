cmake_minimum_required(VERSION 2.8)

SET(CPACK_INCLUDE_TOPLEVEL_DIRECTORY FALSE)
SET(CPACK_PACKAGE_FILE_NAME luasql-${VERSION_FULL})

SET(CPACK_GENERATOR "ZIP")
INCLUDE(CPack)

# Build the ivy file.
CONFIGURE_FILE(ivy.xml ivy-${VERSION_FULL}.xml)

#-----------------------------------------------------------------------------
#
# Install the 32bit files.
#
INSTALL(FILES ${MUHKUH_WIN32_INSTALL}/lua_plugins/luasql/mysql.dll
        DESTINATION windows_x86/lua_plugins/luasql
)


#-----------------------------------------------------------------------------
#
# Install the 64bit files.
#
INSTALL(FILES ${MUHKUH_WIN64_INSTALL}/lua_plugins/luasql/mysql.dll
        DESTINATION windows_amd64/lua_plugins/luasql
)


#-----------------------------------------------------------------------------

INSTALL(FILES install.xml
        DESTINATION .)


#-----------------------------------------------------------------------------
#
# Filter the pom.xml file.
#
SET(POM_ARTIFACT_ID  "luasql")
SET(POM_GROUP_ID     "com.github.keplerproject.lua")
SET(POM_VERSION      "${VERSION_FULL}")
SET(POM_PACKAGING    "zip")
CONFIGURE_FILE(${CMAKE_CURRENT_SOURCE_DIR}/../pom.xml pom.xml)
