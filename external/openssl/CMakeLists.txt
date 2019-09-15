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
	# We are not cross compiling.
	# There might be no toolchain file with the desired processor architecture.
	# This introduces strange situations like an X86_64 processor running a
	# 32bit system. While this sounds like something dumb to do on a real
	# machine, it is a good choice for virtual build machines using docker.
	# The consequence is not to use "CMAKE_SYSTEM_PROCESSOR" as this is always
	# reports "x86_64" on a standard docker machine.
	IF((CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3456]86$") OR (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64"))
		IF(CMAKE_SIZEOF_VOID_P EQUAL 4)
			SET(CONFIGURE_TARGET "linux-x86")
		ELSEIF(CMAKE_SIZEOF_VOID_P EQUAL 8)
			SET(CONFIGURE_TARGET "linux-x86_64")
		ELSE(CMAKE_SIZEOF_VOID_P EQUAL 4)
			MESSAGE(FATAL_ERROR "Unsupported size of void.")
		ENDIF(CMAKE_SIZEOF_VOID_P EQUAL 4)
	ELSE((CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3456]86$") OR (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64"))
		MESSAGE(FATAL_ERROR "Unsupported system processor.")
	ENDIF((CMAKE_SYSTEM_PROCESSOR MATCHES "^i[3456]86$") OR (CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64"))
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
