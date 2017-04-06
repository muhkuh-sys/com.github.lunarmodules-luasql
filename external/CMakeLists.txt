cmake_minimum_required(VERSION 2.8)

PROJECT("external")

# Python is used for some test scripts.
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)

#----------------------------------------------------------------------------
#
# Include the projects in the subdirectories.
#
ADD_SUBDIRECTORY(mysql)
ADD_SUBDIRECTORY(sqlite3)
