# LICENSE
#   Copyright (c) 2016 Ruben Kerkhof <ruben@rubenkerkhof.com>
#
#   Copying and distribution of this file, with or without modification, are
#   permitted in any medium without royalty provided the copyright notice
#   and this notice are preserved. This file is offered as-is, without any
#   warranty.
#
#serial 1

AC_ARG_VAR([BOOST_CPPFLAGS], [Preprocessor flags for Boost])
AC_ARG_VAR([BOOST_LDFLAGS], [Linker flags for Boost])

AC_DEFUN([PDNS_CHECK_BOOST], [
  SAVE_CPPFLAGS="$CPPFLAGS"; CPPFLAGS="$BOOST_CPPFLAGS $CPPFLAGS"

  AC_CHECK_HEADERS([boost/version.hpp], [], [
    AC_MSG_ERROR([Unable to find Boost headers])
  ])

  AC_MSG_CHECKING([for Boost version >= 1.35])
  AC_PREPROC_IFELSE(
    [AC_LANG_PROGRAM(
      [[#include <boost/version.hpp>]],
      [[
        #if BOOST_VERSION < 103500
        #error invalid version
        #endif
      ]]
    )],
    [AC_MSG_RESULT([yes])],
    [AC_MSG_ERROR([Boost is too old])],
  )
  CPPFLAGS="$SAVE_CPPFLAGS"
])

AC_DEFUN([PDNS_CHECK_BOOST_PROGRAM_OPTIONS], [
  SAVE_CPPFLAGS="$CPPFLAGS"; CPPFLAGS="$BOOST_CPPFLAGS $CPPFLAGS"

  AC_CHECK_HEADERS([boost/program_options.hpp], [], [
    AC_MSG_ERROR([Unable to find Boost.Program_options headers])
  ])

  AC_MSG_CHECKING([for Boost.Program_options])
  SAVE_LDFLAGS="$LDFLAGS"; LDFLAGS="$BOOST_LDFLAGS $LDFLAGS"; SAVE_LIBS="$LIBS"; LIBS="-lboost_program_options"
  AC_LINK_IFELSE(
    [AC_LANG_PROGRAM(
     [[#include <boost/program_options.hpp>]],
     [[
       boost::program_options::variables_map vm;
       boost::program_options::notify(vm);
     ]]
    )],
    [
      AC_MSG_RESULT([yes])
      BOOST_UNIT_TEST_FRAMEWORK_LIBS="$LIBS"
    ],
    [AC_MSG_ERROR([Unable to find Boost.Program_options library])]
  )
  CPPFLAGS="$SAVE_CPPFLAGS"; LDFLAGS="$SAVE_LDFLAGS"; LIBS="$SAVE_LIBS"
  AC_SUBST([BOOST_UNIT_TEST_FRAMEWORK_LIBS])
])

AC_DEFUN([PDNS_CHECK_BOOST_UNIT_TEST], [
  SAVE_CPPFLAGS="$CPPFLAGS"; CPPFLAGS="$BOOST_CPPFLAGS $CPPFLAGS"
  AC_CHECK_HEADERS([boost/test/unit_test.hpp], [], [
    AC_MSG_ERROR([Unable to find Boost.Test headers])
  ])

  AC_MSG_CHECKING([for Boost.Test])
  SAVE_LDFLAGS="$LDFLAGS"; LDFLAGS="$BOOST_LDFLAGS $LDFLAGS"; SAVE_LIBS="$LIBS"; LIBS="-lboost_unit_test_framework"
  AC_LINK_IFELSE(
    [AC_LANG_SOURCE(
     [[
       #define BOOST_TEST_MODULE autoconf
       #define BOOST_TEST_DYN_LINK
       #define BOOST_TEST_NO_MAIN
       #include <boost/test/unit_test.hpp>

       BOOST_AUTO_TEST_CASE(autoconf)
       {
         BOOST_CHECK(true);
       }

       int main(int argc, char *argv[])
       {
         return boost::unit_test::unit_test_main( &init_unit_test, argc, argv );
       }
     ]]
    )],
    [
      AC_MSG_RESULT([yes])
      BOOST_PROGRAM_OPTIONS_LIBS="$LIBS"
    ],
    [AC_MSG_ERROR([Unable to find Boost.Test library])]
  )
  CPPFLAGS="$SAVE_CPPFLAGS"; LDFLAGS="$SAVE_LDFLAGS"; LIBS="$SAVE_LIBS"
  AC_SUBST([BOOST_PROGRAM_OPTIONS_LIBS])
])
