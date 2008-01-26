# ===========================================================================
# DirifyPlus ver (1.5) by CrysClouse
#
# Modifications by Everitz Consulting
#   1) Leave decimals and hyphens in the string
#   2) Provide option "a(x)" to leave untouched
#   3) Process default option of "xlu"
# ===========================================================================
use strict;

use MT;
use MT::Template::Context;

# version
use vars qw($VERSION);
$VERSION = '1.5.3';

my $about = {
  name => 'MT-DirifyPlusPlus',
  description => 'A global filter to enhance dirify options.',
  author_name => 'Everitz Consulting',
  author_link => 'http://everitz.com/',
  version => $VERSION,
};
MT->add_plugin(new MT::Plugin($about));

MT::Template::Context->add_global_filter(dirifyplus => sub
 {
   use MT::Util qw( remove_html convert_high_ascii);
   my $t = $_[1];
   my $a = substr($t, 0, 1);
   my ($b, $c);
   if ($a eq '1') {
     $a = 'x';
     $b = 'l';
     $c = 'u';
   } else {
     $b = substr($t, 1, 1);
     $c = substr($t, 2, 1);
   }

   my $s = $_[0];

   $s = convert_high_ascii($s); ## convert high-ASCII chars to 7bit.
   $s = remove_html($s);        ## remove HTML tags.
   $s =~ s!&[^;\s]+;!!g;        ## remove HTML entities.
   $s =~ s![^\w\s\\\/\.\-]!!g;  ## remove non-word/space'\' & '/' chars, non-decimal, non-hyphen.

   if ($b eq "l")
    {
    $s =  lc $s;;               ## lower-case.
    }
   elsif ($b eq "s")
    {
                                ## original case -- do nothing
    }
   elsif ($b eq "i")
    {
    $s =  lc $s;;               ## lower-case.
    $s =~ s!(\b.)!\U$1!g;       ## captialize words
    }
   elsif ($b eq "c")
    {
    $s =~ s!(\b.)!\U$1!g;       ## captialize words
    }

   if ($a eq "p")
    {
    $s =~ s![^\w\s]!!g;         ## remove non-word/space chars.
    }
   elsif ($a eq "s")
    {
    $s =~ s![^\w\s\/]!!g;       ## remove non-word/space'/' chars.
    }
   elsif ($a eq "b")
    {
    $s =~ s![^\w\s\\]!!g;       ## remove non-word/space'\' chars.
    }
   elsif ($a eq "c")
    {
    $s =~ s![^\w\s\\]!!g;       ## remove non-word/space'\' chars.
    $s =~ tr!\\!\/!s;           ## reverse backslashes
    }
   elsif ($a eq "r")
    {
    $s =~ s![^\w\s\/]!!g;       ## remove non-word/space'/' chars.
    $s =~ tr!\/!\\!s;           ## reverse slashes
    }
   elsif ($a eq "x")
    {
                                ## all set -- do nothing
    }

   if (($c eq "u") || (!$c))
    {
    $s =~ tr! !_!s;             ## change space chars to underscores.
    }
   elsif ($c eq "n")
    {
    $s =~ s![\s_]+!!g;          ## delete space
    }
   elsif ($c eq "d")
    {
    $s =~ tr! !-!s;             ## change space chars to dashes.
    }
  $s;
});