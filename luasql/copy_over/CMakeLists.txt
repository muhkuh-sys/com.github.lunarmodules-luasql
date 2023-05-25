cmake_minimum_required(VERSION 2.8)

PROJECT("org.muhkuh.lua-luasql")

# Python is used for the test scripts.
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)

ENABLE_TESTING()

# Link to pthread.
SET(THREADS_PREFER_PTHREAD_FLAG ON)
FIND_PACKAGE(Threads REQUIRED)

#-----------------------------------------------------------------------------
#
# Build the LUA mysql module.
#
ADD_LIBRARY(TARGET_luasql_mysql MODULE
            src/luasql.c src/ls_mysql.c)

# Set the LuaSQL version number.
TARGET_COMPILE_DEFINITIONS(TARGET_luasql_mysql
                            PRIVATE -DLUASQL_VERSION_NUMBER="${LUASQL_VERSION_NUMBER}")

# Link the file as a C++ executable.
SET_TARGET_PROPERTIES(TARGET_luasql_mysql PROPERTIES LINKER_LANGUAGE CXX)

# Add the LUA includes and library.
TARGET_INCLUDE_DIRECTORIES(TARGET_luasql_mysql
                           PRIVATE ${LUA_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(TARGET_luasql_mysql
                      PRIVATE ${LUA_LIBRARIES})

# Add the MySQL includes and library.
TARGET_INCLUDE_DIRECTORIES(TARGET_luasql_mysql
                           PRIVATE ${MARIADB_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(TARGET_luasql_mysql
                      PRIVATE ${MARIADB_LIB} ${GNUTLS_LIBRARY} ${HOGWEED_LIBRARY} ${NETTLE_LIBRARY} ${GMP_LIBRARY})
IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
	TARGET_LINK_LIBRARIES(TARGET_luasql_mysql
	                      PRIVATE crypt32 ws2_32 secur32 shlwapi)
ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

# Link to pthread.
TARGET_LINK_LIBRARIES(TARGET_luasql_mysql
                      PRIVATE Threads::Threads)

# On MinGW link all compiler libraries static.
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	SET_PROPERTY(TARGET TARGET_luasql_mysql PROPERTY LINK_FLAGS "-static-libgcc -static-libstdc++ -static")
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))

# Set the name of the output file to "mysql" without any prefix like "lib".
SET_TARGET_PROPERTIES(TARGET_luasql_mysql PROPERTIES PREFIX "" OUTPUT_NAME "mysql")


#-----------------------------------------------------------------------------
#
# Build the LUA postgresql module.
#
ADD_LIBRARY(TARGET_luasql_postgresql MODULE
            src/luasql.c src/ls_postgres.c)

# Set the LuaSQL version number.
TARGET_COMPILE_DEFINITIONS(TARGET_luasql_postgresql
                            PRIVATE -DLUASQL_VERSION_NUMBER="${LUASQL_VERSION_NUMBER}")

# Link the file as a C++ executable.
SET_TARGET_PROPERTIES(TARGET_luasql_postgresql PROPERTIES LINKER_LANGUAGE CXX)

# Add the LUA includes and library.
TARGET_INCLUDE_DIRECTORIES(TARGET_luasql_postgresql
                           PRIVATE ${LUA_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(TARGET_luasql_postgresql
                      PRIVATE ${LUA_LIBRARIES})

# Add the libpq includes and library.
TARGET_INCLUDE_DIRECTORIES(TARGET_luasql_postgresql
                           PRIVATE ${PQ_INCLUDE_DIR1} ${PQ_INCLUDE_DIR2} ${PQ_INCLUDE_DIR3})
TARGET_LINK_LIBRARIES(TARGET_luasql_postgresql
                      PRIVATE ${PQ_LIBRARY1} ${PQ_LIBRARY2} ${PQ_LIBRARY3})
#IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
#	TARGET_LINK_LIBRARIES(TARGET_luasql_postgresql
#	                      PRIVATE crypt32 ws2_32 secur32 shlwapi)
#ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

## Link to pthread.
TARGET_LINK_LIBRARIES(TARGET_luasql_postgresql
                      PRIVATE Threads::Threads)

# On MinGW link all compiler libraries static.
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	SET_PROPERTY(TARGET TARGET_luasql_postgresql PROPERTY LINK_FLAGS "-static-libgcc -static-libstdc++ -static")
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))

# Set the name of the output file to "postgres" without any prefix like "lib".
SET_TARGET_PROPERTIES(TARGET_luasql_postgresql PROPERTIES PREFIX "" OUTPUT_NAME "postgres")


#-----------------------------------------------------------------------------
#
# Build the LUA sqlite3 module.
#
ADD_LIBRARY(TARGET_luasql_sqlite3 MODULE
            src/luasql.c src/ls_sqlite3.c)

# Set the LuaSQL version number.
TARGET_COMPILE_DEFINITIONS(TARGET_luasql_sqlite3
                            PRIVATE -DLUASQL_VERSION_NUMBER="${LUASQL_VERSION_NUMBER}")

# Link the file as a C++ executable.
SET_TARGET_PROPERTIES(TARGET_luasql_sqlite3 PROPERTIES LINKER_LANGUAGE CXX)

# Add the LUA includes and library.
TARGET_INCLUDE_DIRECTORIES(TARGET_luasql_sqlite3
                           PRIVATE ${LUA_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(TARGET_luasql_sqlite3
                      PRIVATE ${LUA_LIBRARIES})

# Add the SQLite3 includes and library.
TARGET_INCLUDE_DIRECTORIES(TARGET_luasql_sqlite3
                           PRIVATE ${SQLITE_INCLUDE_DIR})
TARGET_LINK_LIBRARIES(TARGET_luasql_sqlite3
                      PRIVATE ${SQLITE_LIB})

IF(UNIX)
	# Link to libdl on linux systems.
	TARGET_LINK_LIBRARIES(TARGET_luasql_sqlite3
	                      PRIVATE dl)

	# Link to pthread.
	TARGET_LINK_LIBRARIES(TARGET_luasql_sqlite3
	                      PRIVATE Threads::Threads)
ENDIF(UNIX)

# On MinGW link all compiler libraries static.
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	SET_PROPERTY(TARGET TARGET_luasql_sqlite3 PROPERTY LINK_FLAGS "-static-libgcc -static-libstdc++")
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))

# Set the name of the output file to "mysql" without any prefix like "lib".
SET_TARGET_PROPERTIES(TARGET_luasql_sqlite3 PROPERTIES PREFIX "" OUTPUT_NAME "sqlite3")


#-----------------------------------------------------------------------------
#
# Install the LUA modules.
#
INSTALL(TARGETS TARGET_luasql_mysql
        LIBRARY DESTINATION ${INSTALL_DIR_LUA_MODULES}/luasql)

INSTALL(TARGETS TARGET_luasql_postgresql
        LIBRARY DESTINATION ${INSTALL_DIR_LUA_MODULES}/luasql)

INSTALL(TARGETS TARGET_luasql_sqlite3
        LIBRARY DESTINATION ${INSTALL_DIR_LUA_MODULES}/luasql)


#-----------------------------------------------------------------------------
#
# Add tests for the modules.
#
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	# Here are the MinGW specific tests.
	ADD_TEST(NAME luasql_mysql_MinGW_DLL_dependencies
	         COMMAND "${PYTHON_EXECUTABLE}" ${TEST_SCRIPT_FOLDER}/mingw_dll_dependencies.py -u lua5.1 -u lua5.2 -u lua5.3 -u lua5.4 $<TARGET_FILE:TARGET_luasql_mysql>)

	ADD_TEST(NAME luasql_postgresql_MinGW_DLL_dependencies
	         COMMAND "${PYTHON_EXECUTABLE}" ${TEST_SCRIPT_FOLDER}/mingw_dll_dependencies.py -u lua5.1 -u lua5.2 -u lua5.3 -u lua5.4 $<TARGET_FILE:TARGET_luasql_postgresql>)

	ADD_TEST(NAME luasql_sqlite3_MinGW_DLL_dependencies
	         COMMAND "${PYTHON_EXECUTABLE}" ${TEST_SCRIPT_FOLDER}/mingw_dll_dependencies.py -u lua5.1 -u lua5.2 -u lua5.3 -u lua5.4 $<TARGET_FILE:TARGET_luasql_sqlite3>)
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
