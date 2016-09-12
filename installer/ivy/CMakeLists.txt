cmake_minimum_required(VERSION 2.8)

PROJECT("org.muhkuh.lua-luasql")

INCLUDE(ExternalProject)
INCLUDE(../../cmake/version.cmake)


GET_FILENAME_COMPONENT(MUHKUH_WIN32_INSTALL "../../build_windows32/luasql/install" ABSOLUTE)
GET_FILENAME_COMPONENT(MUHKUH_WIN64_INSTALL "../../build_windows64/luasql/install" ABSOLUTE)

# The version number is a combination of the LUA version and the packaging.
# The major and minor numbers are taken from the LUA version, i.e. LUA 5.1.5
# results in the package version 5.1 . LUA version 5.2.4 results in the
# package version 5.2 .
# The patch version of the package indicates...
#  1) updates of the LUA source in the same major and minor, e.g. 5.1.4 -> 5.1.5
#  2) updates of the packaging
#
SET(CPACK_PACKAGE_VERSION_MAJOR 2)
SET(CPACK_PACKAGE_VERSION_MINOR 3)
SET(CPACK_PACKAGE_VERSION_PATCH 2)
SET(VERSION_FULL ${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH})


SET(PACKAGE_CMAKE_ARGS "")
LIST(APPEND PACKAGE_CMAKE_ARGS "-DMUHKUH_WIN32_INSTALL=${MUHKUH_WIN32_INSTALL}")
LIST(APPEND PACKAGE_CMAKE_ARGS "-DMUHKUH_WIN64_INSTALL=${MUHKUH_WIN64_INSTALL}")
LIST(APPEND PACKAGE_CMAKE_ARGS "-DCPACK_PACKAGE_VERSION_MAJOR=${CPACK_PACKAGE_VERSION_MAJOR}")
LIST(APPEND PACKAGE_CMAKE_ARGS "-DCPACK_PACKAGE_VERSION_MINOR=${CPACK_PACKAGE_VERSION_MINOR}")
LIST(APPEND PACKAGE_CMAKE_ARGS "-DCPACK_PACKAGE_VERSION_PATCH=${CPACK_PACKAGE_VERSION_PATCH}")
LIST(APPEND PACKAGE_CMAKE_ARGS "-DVERSION_FULL=${VERSION_FULL}")
LIST(APPEND PACKAGE_CMAKE_ARGS "-DPROJECT_VERSION_VCS=${PROJECT_VERSION_VCS}")

ExternalProject_Add(TARGET_luasql
                    SOURCE_DIR ${CMAKE_CURRENT_SOURCE_DIR}/luasql
                    CMAKE_ARGS ${PACKAGE_CMAKE_ARGS}
                    INSTALL_COMMAND make package
)


# Copy the files to an easy to remember path.
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/TARGET_luasql-prefix/src/TARGET_luasql-build/luasql-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}.zip
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR})
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/TARGET_luasql-prefix/src/TARGET_luasql-build/ivy-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}.xml
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR})

# Create a copy of the artifacts without a version number in the filename.
# This allows easy deploy to GitHub.
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/TARGET_luasql-prefix/src/TARGET_luasql-build/luasql-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}.zip
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
        RENAME luasql.zip)
INSTALL(FILES ${CMAKE_CURRENT_BINARY_DIR}/TARGET_luasql-prefix/src/TARGET_luasql-build/ivy-${CPACK_PACKAGE_VERSION_MAJOR}.${CPACK_PACKAGE_VERSION_MINOR}.${CPACK_PACKAGE_VERSION_PATCH}.xml
        DESTINATION ${CMAKE_CURRENT_BINARY_DIR}
        RENAME ivy.xml)

#----------------------------------------------------------------------------

