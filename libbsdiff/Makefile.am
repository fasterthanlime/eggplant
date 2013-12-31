AUTOMAKE_OPTIONS = subdir-objects
ACLOCAL_AMFLAGS = ${ACLOCAL_FLAGS} -I m4

lib_LTLIBRARIES = libbsdiff-@BSDIFF_API_VERSION@.la
libbsdiff_@BSDIFF_API_VERSION@_la_SOURCES = src/bsdiff.c \
  					    src/bspatch.c

libbsdiff_@BSDIFF_API_VERSION@_la_LDFLAGS = -version-info $(BSDIFF_SO_VERSION)

bsdiff_includedir = $(includedir)/bsdiff-$(BSDIFF_API_VERSION)
nobase_bsdiff_include_HEADERS = src/bsdiff.h \
				src/bspatch.h

bsdiff_libincludedir = $(libdir)/bsdiff-$(BSDIFF_API_VERSION)/include
nodist_bsdiff_libinclude_HEADERS = bsdiffconfig.h

pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = bsdiff-$(BSDIFF_API_VERSION).pc

dist_noinst_SCRIPTS = autogen.sh

