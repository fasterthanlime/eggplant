AUTOMAKE_OPTIONS = subdir-objects
ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS} -I m4

lib_LTLIBRARIES = libmd5-@MD5_API_VERSION@.la
libmd5_@MD5_API_VERSION@_la_SOURCES = md5/md5.c

libmd5_@MD5_API_VERSION@_la_LDFLAGS = -version-info $(MD5_SO_VERSION)

md5_includedir = $(includedir)/md5-$(MD5_API_VERSION)
nobase_md5_include_HEADERS = md5/md5.h

md5_libincludedir = $(libdir)/md5-$(MD5_API_VERSION)/include
nodist_md5_libinclude_HEADERS = md5config.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = md5-$(MD5_API_VERSION).pc

dist_noinst_SCRIPTS = autogen.sh

