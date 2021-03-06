use strict;
use warnings;

package Moo;
sub bbb  { };
sub new  { bless {}, shift }
sub aaa  { };
sub _ccc { };
sub _zzz { };
sub _ddd { };
1;

package main;
use Test::More;
BEGIN {
    $ENV{ANSI_COLORS_DISABLED} = 1;
    use File::HomeDir::Test;  # avoid user's .dataprinter
};

use Data::Printer {
    'sort_keys' => 0,
    'class'     => {
        'sort_methods' => 0,
    },
};

my $data =  { foo => 3, bar => 2, baz => 1 };
my $string = "\\ {\n";

# perl does not guarantee that hash keys are
# returned in the same order for each build,
# but it should be the same order for the
# same perl.
my @keys = keys %$data;
foreach my $i ( 0 .. $#keys) {
    my $key = $keys[$i];
    $string .= "    $key   " . $data->{$key};
    $string .= ($i == $#keys ? "\n" : ",\n");
}
$string .= '}';


is( p($data), $string, 'sort_keys => 0' );


my $obj = Moo->new;

my $res = p($obj);
ok( $res =~ m/public methods \(3\) : (.+)/,
    'found public methods'
);
my $method_list = $1;
isnt($method_list, 'aaa, bbb, new',
     'unordered public methods'
);

ok( $res =~ m/private methods \(3\) : (.+)/,
    'found private methods'
);
$method_list = $1;
isnt($method_list, '_ccc, _ddd, _zzz',
     'unordered private methods'
);


done_testing;
