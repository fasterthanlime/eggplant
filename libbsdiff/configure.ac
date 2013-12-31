AC_INIT([bsdiff], [1.0], [amoswenger@gmail.com])
AC_PREREQ([2.59])
AM_INIT_AUTOMAKE([1.10 -Wall no-define])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_PROG_CC
AM_PROG_AR
LT_INIT([disable-shared])

AC_SUBST([BSDIFF_SO_VERSION], [1:0:0])
AC_SUBST([BSDIFF_API_VERSION], [1.0])

AC_CONFIG_FILES([Makefile bsdiff-${BSDIFF_API_VERSION}.pc:bsdiff.pc.in])
AC_OUTPUT
