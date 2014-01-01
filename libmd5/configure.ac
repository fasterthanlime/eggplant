AC_INIT([md5], [1.0], [amoswenger@gmail.com])
AC_PREREQ([2.59])
AM_INIT_AUTOMAKE([1.10 -Wall no-define])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h md5config.h])
AC_PROG_CC
AM_PROG_AR
LT_INIT([disable-shared])

AC_SUBST([MD5_SO_VERSION], [1:0:0])
AC_SUBST([MD5_API_VERSION], [1.0])

AC_CONFIG_FILES([Makefile md5-${MD5_API_VERSION}.pc:md5.pc.in])
AC_OUTPUT
