cmake_minimum_required(VERSION 2.8)

PROJECT("org.muhkuh.lua-luasql")

ENABLE_TESTING()

#-----------------------------------------------------------------------------
#
# Build the LUA mysql module.
#
IF(OPTION_BUILD_MYSQL)
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
	                           PRIVATE ${LIBMYSQLCLIENT_INCLUDE_DIRECTORIES})
	TARGET_LINK_LIBRARIES(TARGET_luasql_mysql
	                      PRIVATE ${LIBMYSQLCLIENT_LIBRARY})
	IF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")
		TARGET_LINK_LIBRARIES(TARGET_luasql_mysql
		                      PRIVATE ws2_32 secur32)
	ENDIF(${CMAKE_SYSTEM_NAME} STREQUAL "Windows")

	# On MinGW link all compiler libraries static.
	IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
		SET_PROPERTY(TARGET TARGET_luasql_mysql PROPERTY LINK_FLAGS "-static-libgcc -static-libstdc++")
	ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))

	# Set the name of the output file to "mysql" without any prefix like "lib".
	SET_TARGET_PROPERTIES(TARGET_luasql_mysql PROPERTIES PREFIX "" OUTPUT_NAME "mysql")
ENDIF(OPTION_BUILD_MYSQL)


#-----------------------------------------------------------------------------
#
# Build the LUA sqlite3 module.
#
IF(OPTION_BUILD_SQLITE3)
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
	                           PRIVATE ${LIBSQLITE3_INCLUDE_DIRECTORIES})
	TARGET_LINK_LIBRARIES(TARGET_luasql_sqlite3
	                      PRIVATE ${LIBSQLITE3_LIBRARY})

	# On MinGW link all compiler libraries static.
	IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
		SET_PROPERTY(TARGET TARGET_luasql_sqlite3 PROPERTY LINK_FLAGS "-static-libgcc -static-libstdc++")
	ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))

	# Set the name of the output file to "mysql" without any prefix like "lib".
	SET_TARGET_PROPERTIES(TARGET_luasql_sqlite3 PROPERTIES PREFIX "" OUTPUT_NAME "sqlite3")
ENDIF(OPTION_BUILD_SQLITE3)


#-----------------------------------------------------------------------------
#
# Install the LUA modules.
#
IF(OPTION_BUILD_MYSQL)
	INSTALL(TARGETS TARGET_luasql_mysql
	        LIBRARY DESTINATION ${INSTALL_DIR_LUA_MODULES}/luasql)
ENDIF(OPTION_BUILD_MYSQL)

IF(OPTION_BUILD_SQLITE3)
	INSTALL(TARGETS TARGET_luasql_sqlite3
	        LIBRARY DESTINATION ${INSTALL_DIR_LUA_MODULES}/luasql)
ENDIF(OPTION_BUILD_SQLITE3)


#-----------------------------------------------------------------------------
#
# Add tests for the modules.
#
IF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
	# Here are the MinGW specific tests.
	IF(OPTION_BUILD_MYSQL)
		ADD_TEST(NAME luasql_mysql_MinGW_DLL_dependencies
		         COMMAND "${PYTHON_EXECUTABLE}" ${TEST_SCRIPT_FOLDER}/mingw_dll_dependencies.py -u lua5.1 $<TARGET_FILE:TARGET_luasql_mysql>)
	ENDIF(OPTION_BUILD_MYSQL)

	IF(OPTION_BUILD_SQLITE3)
		ADD_TEST(NAME luasql_sqlite3_MinGW_DLL_dependencies
		         COMMAND "${PYTHON_EXECUTABLE}" ${TEST_SCRIPT_FOLDER}/mingw_dll_dependencies.py -u lua5.1 $<TARGET_FILE:TARGET_luasql_sqlite3>)
	ENDIF(OPTION_BUILD_SQLITE3)
ENDIF((${CMAKE_SYSTEM_NAME} STREQUAL "Windows") AND (${CMAKE_COMPILER_IS_GNUCC}))
