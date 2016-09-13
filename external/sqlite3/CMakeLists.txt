cmake_minimum_required(VERSION 2.8)

PROJECT("sqlite3")

INCLUDE(ExternalProject)


SET(VERSION_EXTERNAL "3140200")


#----------------------------------------------------------------------------
#
# Build the project for the target architecture.
#
SET(SQLITE3_CMAKE_ARGS "")
LIST(APPEND SQLITE3_CMAKE_ARGS "-DCMAKE_INSTALL_PREFIX=install")
LIST(APPEND SQLITE3_CMAKE_ARGS "-DCMAKE_C_FLAGS=${CMAKE_C_FLAGS}")
LIST(APPEND SQLITE3_CMAKE_ARGS "-DCMAKE_SYSTEM_NAME=${CMAKE_SYSTEM_NAME}")
LIST(APPEND SQLITE3_CMAKE_ARGS "-DCMAKE_C_COMPILER=${CMAKE_C_COMPILER}")
LIST(APPEND SQLITE3_CMAKE_ARGS "-DCMAKE_CXX_COMPILER=${CMAKE_CXX_COMPILER}")
IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	LIST(APPEND SQLITE3_CMAKE_ARGS "-DCMAKE_RC_COMPILER=${CMAKE_RC_COMPILER}")
ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

ExternalProject_Add(TARGET_sqlite3
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/sqlite3-${VERSION_EXTERNAL}
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/sqlite-amalgamation-${VERSION_EXTERNAL}.zip
                    URL_HASH SHA1=716f8dbaf8e6a0b460845ae9df394285d0f3e88f
                    PATCH_COMMAND ${CMAKE_COMMAND} -E copy_directory ${CMAKE_CURRENT_SOURCE_DIR}/copy_over ${CMAKE_CURRENT_BINARY_DIR}/sqlite3-${VERSION_EXTERNAL}/src/TARGET_sqlite3
                    CMAKE_ARGS ${SQLITE3_CMAKE_ARGS}
                    INSTALL_COMMAND ${CMAKE_MAKE_PROGRAM} install
)



# 3) Provide all variables for the build.
SET(LIBRARY ${CMAKE_CURRENT_BINARY_DIR}/sqlite3-${VERSION_EXTERNAL}/src/TARGET_sqlite3-build/install/lib/libsqlite3.a)
SET(INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR}/sqlite3-${VERSION_EXTERNAL}/src/TARGET_sqlite3-build/install/include)

#----------------------------------------------------------------------------
#
# Create an imported library target.
#
SET(LIBSQLITE3_LIBRARY              ${LIBRARY}              CACHE INTERNAL "The libsqlite3 library with the complete path.")
SET(LIBSQLITE3_INCLUDE_DIRECTORIES  ${INCLUDE_DIRECTORIES}  CACHE INTERNAL "The include folders for the library headers. The list must be separated with whitespace.")
