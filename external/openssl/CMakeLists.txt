cmake_minimum_required(VERSION 3.7)

PROJECT("openssl")

INCLUDE(ExternalProject)

# Python is used for the patch script.
FIND_PACKAGE(PythonInterp 2.7 REQUIRED)

#----------------------------------------------------------------------------
#
# Build the project.
#
SET(CONFIGURE_ARGS "")

IF(${CMAKE_CROSSCOMPILING})
	IF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
		# Get the prefix of the compiler.
		GET_FILENAME_COMPONENT(GCC_BASENAME ${CMAKE_C_COMPILER} NAME)
		IF(${GCC_BASENAME} MATCHES "([^-]+-[^-]+-[^-]+)-gcc")
			SET(COMPILER_PREFIX "${CMAKE_MATCH_1}-")
		ELSE(${GCC_BASENAME} MATCHES "([^-]+-[^-]+-[^-]+)-gcc")
			MESSAGE(FATAL_ERROR "Failed to extract the compiler prefix from the C compiler ${CMAKE_C_COMPILER}")
		ENDIF(${GCC_BASENAME} MATCHES "([^-]+-[^-]+-[^-]+)-gcc")
	ELSE("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")
		MESSAGE(FATAL_ERROR "Cross compiling detected, but not using GCC. This is currently not supported by the CMake wrapper for OpenSSL.")
	ENDIF("${CMAKE_CXX_COMPILER_ID}" STREQUAL "GNU")

	IF(CMAKE_SYSTEM_PROCESSOR STREQUAL "i686")
		SET(CONFIGURE_TARGET "mingw")
	ELSEIF(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
		SET(CONFIGURE_TARGET "mingw64")
	ELSEIF(CMAKE_SYSTEM_PROCESSOR STREQUAL "arm")
		SET(CONFIGURE_TARGET "linux-aarch64")
	ELSE(CMAKE_SYSTEM_PROCESSOR STREQUAL "i686")
		MESSAGE(FATAL_ERROR "Unsupported system processor.")
	ENDIF(CMAKE_SYSTEM_PROCESSOR STREQUAL "i686")

ELSE(${CMAKE_CROSSCOMPILING})
	IF(CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3456]86$")
		SET(CONFIGURE_TARGET "linux-x86")
	ELSEIF(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
		SET(CONFIGURE_TARGET "linux-x86_64")
	ELSE(CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3456]86$")
		MESSAGE(FATAL_ERROR "Unsupported system processor.")
	ENDIF(CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3456]86$")


#ExternalProject_Add(TARGET_openssl
#                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/openssl
#                    URL ${CMAKE_CURRENT_SOURCE_DIR}/openssl-1.1.1c.tar.gz
#                    URL_HASH SHA1=71b830a077276cbeccc994369538617a21bee808
#                    CONFIGURE_COMMAND cd ../TARGET_openssl && ${CONFIGURE_CMD} ${CONFIGURE_ARGS}
#                    BUILD_COMMAND make -C ../TARGET_openssl
#                    INSTALL_COMMAND make -C ../TARGET_openssl install DESTDIR=${CMAKE_CURRENT_BINARY_DIR}/install
#)
ENDIF(${CMAKE_CROSSCOMPILING})

SET(ZLIB_INCLUDE "${CMAKE_BINARY_DIR}/../lua5.1/build_requirements/jonchki/install/dev/include")
SET(ZLIB_LIBDIR "${CMAKE_BINARY_DIR}/../lua5.1/build_requirements/jonchki/install/dev/lib")
MESSAGE("ZLIB include: ${ZLIB_INCLUDE}")

ExternalProject_Add(TARGET_openssl
                    PREFIX ${CMAKE_CURRENT_BINARY_DIR}/openssl
                    URL ${CMAKE_CURRENT_SOURCE_DIR}/openssl-1.1.1c.tar.gz
                    URL_HASH SHA1=71b830a077276cbeccc994369538617a21bee808
                    CONFIGURE_COMMAND ${CMAKE_CURRENT_BINARY_DIR}/openssl/src/TARGET_openssl/Configure --cross-compile-prefix=${COMPILER_PREFIX} zlib -fPIC no-shared -I${ZLIB_INCLUDE} -L${ZLIB_LIBDIR} ${CONFIGURE_TARGET}
                    BUILD_COMMAND make
                    INSTALL_COMMAND make install DESTDIR=${CMAKE_CURRENT_BINARY_DIR}/install
)
