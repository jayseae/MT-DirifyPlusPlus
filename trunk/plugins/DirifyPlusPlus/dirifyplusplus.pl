# ===========================================================================
# A Movable Type global filter to enhance dirify options.
# Copyright 2004, 2005 Everitz Consulting <everitz.com>, Crys Clouse.
#
# This program is free software:  You may redistribute it and/or modify it
# it under the terms of the Artistic License version 2 as published by the
# Open Source Initiative.
#
# This program is distributed in the hope that it will be useful but does
# NOT INCLUDE ANY WARRANTY; Without even the implied warranty of FITNESS
# FOR A PARTICULAR PURPOSE.
#
# You should have received a copy of the Artistic License with this program.
# If not, see <http://www.opensource.org/licenses/artistic-license-2.0.php>.
# ===========================================================================
package MT::Plugin::DirifyPlusPlus;

use strict;

use base qw( MT::Plugin );

use MT;
use MT::Template::Context;
use MT::Util qw(convert_high_ascii remove_html);

# version
use vars qw($VERSION);
$VERSION = '1.5.5';

my $plugin = MT::Plugin::DirifyPlusPlus->new({
  id          => 'DirifyPlusPlus',
  key         => 'dirifyplusplus',
  name        => 'MT-DirifyPlusPlus',
  description => qq(<MT_TRANS phrase="A global filter to enhance dirify options.">),
  author_name => 'Everitz Consulting',
  author_link => 'http://everitz.com/',
  version     => $VERSION,
});
MT->add_plugin($plugin);

MT::Template::Context->add_global_filter(dirifyplus => sub
 {
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