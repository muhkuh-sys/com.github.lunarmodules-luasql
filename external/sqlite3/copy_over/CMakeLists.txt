cmake_minimum_required(VERSION 2.8)

PROJECT("sqlite3")

ENABLE_TESTING()

#-----------------------------------------------------------------------------
#
# Build the sqlite3 library.
#
ADD_LIBRARY(TARGET_sqlite3 STATIC
            shell.c
            sqlite3.c)

# Set the name of the output file to "sqlite3".
SET_TARGET_PROPERTIES(TARGET_sqlite3 PROPERTIES OUTPUT_NAME "sqlite3")

# This static library will be linked with a shared object later. Add "-fPIC" on GCC systems or X64 builds break.
IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU"  AND  "${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")
        SET_TARGET_PROPERTIES(TARGET_sqlite3 PROPERTIES COMPILE_FLAGS -fPIC)
ENDIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU"  AND  "${CMAKE_SYSTEM_NAME}" STREQUAL "Linux")

INSTALL(TARGETS TARGET_sqlite3
        DESTINATION lib)

INSTALL(FILES sqlite3ext.h sqlite3.h
        DESTINATION include)
