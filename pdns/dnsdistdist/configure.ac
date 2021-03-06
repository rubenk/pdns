AC_INIT([dnsdist], m4_esyscmd(build-aux/gen-version))
AM_INIT_AUTOMAKE([foreign dist-bzip2 parallel-tests 1.11 subdir-objects])
AM_SILENT_RULES([yes])
AC_CONFIG_MACRO_DIR([m4])
AC_CONFIG_HEADERS([config.h])
AC_PROG_CC
AC_PROG_CXX
PDNS_CHECK_LIBSODIUM
DNSDIST_CHECK_RAGEL
AC_PROG_LIBTOOL
PDNS_CHECK_LIBEDIT([mandatory])
PDNS_CHECK_CLOCK_GETTIME
BOOST_REQUIRE([1.35])
BOOST_FOREACH
PDNS_ENABLE_UNIT_TESTS
PDNS_CHECK_RE2
DNSDIST_ENABLE_DNSCRYPT

AC_SUBST([YAHTTP_CFLAGS], ['-I$(top_srcdir)/ext/yahttp'])
AC_SUBST([YAHTTP_LIBS], ['$(top_builddir)/ext/yahttp/yahttp/libyahttp.la'])

PDNS_WITH_LUAJIT
AS_IF([test "x$with_luajit" = "xno"], [
  PDNS_WITH_LUA
])
AS_IF([test "x$LUAPC" = "x" -a "x$LUAJITPC" = "x"], [
  AC_MSG_ERROR([Neither Lua nor LuaJIT found, Lua support is not optional])
])

AX_CXX_COMPILE_STDCXX_11(ext,mandatory)

AC_MSG_CHECKING([whether we will enable compiler security checks])
AC_ARG_ENABLE([hardening],
  [AS_HELP_STRING([--disable-hardening],[disable compiler security checks @<:@default=no@:>@])],
  [enable_hardening=$enableval],
  [enable_hardening=yes]
)
AC_MSG_RESULT([$enable_hardening])

AS_IF([test "x$enable_hardening" != "xno"], [
  AC_CC_PIE
  AC_CC_STACK_PROTECTOR
  AC_CC_PARAM_SSP_BUFFER_SIZE([4])
  AC_CC_D_FORTIFY_SOURCE
  AC_LD_RELRO
])

PDNS_ENABLE_SANITIZERS

PDNS_CHECK_PANDOC

LDFLAGS="$RELRO_LDFLAGS $LDFLAGS"

AS_IF([test "x$static" != "xyes"], [
  CFLAGS="$PIE_CFLAGS $CFLAGS"
  CXXFLAGS="$PIE_CFLAGS $CXXFLAGS"
  PROGRAM_LDFLAGS="$PIE_LDFLAGS $PROGRAM_LDFLAGS"
])
AC_SUBST([PROGRAM_LDFLAGS])

AC_SUBST([AM_CPPFLAGS],
  ["AS_ESCAPE([-I$(top_builddir) -I$(top_srcdir)]) -Wall -O3 -pthread $BOOST_CPPFLAGS"]
)

AC_CONFIG_FILES([Makefile
	ext/yahttp/Makefile
	ext/yahttp/yahttp/Makefile])

AC_OUTPUT
