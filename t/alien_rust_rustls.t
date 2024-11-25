use Test2::V0 -no_srand => 1;
use Test::Alien;
use Test::Alien::Diag;
use Alien::Rust::rustls;
use Data::Section::Simple qw( get_data_section );

alien_ok 'Alien::Rust::rustls';

xs_ok get_data_section('foo.xs'), with_subtest {
  my $module = shift;
  my $version = $module->version;
  is $version, D();
  note "version = $version";
};

ffi_ok { symbols => ['rustls_version'] };

done_testing;

__DATA__

@@ foo.xs
#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <rustls.h>

const char *
version(const char *class)
{
  struct rustls_str v = rustls_version();
  /* This leaks so don't do it "for real life" */
  return strndup(v.data, v.len);
}

MODULE = TA_MODULE PACKAGE = TA_MODULE

const char *version(class)
    const char *class
