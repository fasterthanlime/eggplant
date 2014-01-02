AUTOMAKE_OPTIONS = subdir-objects
ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS} -I m4

lib_LTLIBRARIES = libsha1-@SHA1_API_VERSION@.la
libsha1_@SHA1_API_VERSION@_la_SOURCES = sha1/sha1.c

libsha1_@SHA1_API_VERSION@_la_LDFLAGS = -version-info $(SHA1_SO_VERSION)

sha1_includedir = $(includedir)/sha1-$(SHA1_API_VERSION)
nobase_sha1_include_HEADERS = sha1/sha1.h

sha1_libincludedir = $(libdir)/sha1-$(SHA1_API_VERSION)/include
nodist_sha1_libinclude_HEADERS = sha1config.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = sha1-$(SHA1_API_VERSION).pc

dist_noinst_SCRIPTS = autogen.sh

