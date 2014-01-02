AC_INIT([sha1], [1.0], [amoswenger@gmail.com])
AC_PREREQ([2.59])
AM_INIT_AUTOMAKE([1.10 -Wall no-define])

AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h sha1config.h])
AC_PROG_CC
AM_PROG_AR
LT_INIT([disable-shared])

AC_SUBST([SHA1_SO_VERSION], [1:0:0])
AC_SUBST([SHA1_API_VERSION], [1.0])

AC_CONFIG_FILES([Makefile sha1-${SHA1_API_VERSION}.pc:sha1.pc.in])
AC_OUTPUT
