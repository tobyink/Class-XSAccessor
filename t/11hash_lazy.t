use strict;
use warnings;

package CXSATest;

my $count_foo;
my $count_bar;

use Class::XSAccessor
#	lazy_getters   => { foo => 'foo' },
	lazy_accessors => { foo => 'foo', bar => "b\0ar" },
	;

sub new {
	my $class = shift;
	bless +{ @_ }, $class;
}

sub _build_foo { $count_foo++; no warnings; return (333 + shift->bar); }
sub _build_bar { $count_bar++; return 666; }

package main;

use Test::More tests => 9;

my $obj = CXSATest->new();

ok(!exists($obj->{foo}), "Key 'foo' not set");
ok(!exists($obj->{bar}), "Key 'bar' not set");

is($obj->foo, 999, '$obj->foo accessor returns expected value');

is($obj->{foo}, 999, "Key 'foo' set; correct value");
is($obj->{bar}, 666, "Key 'bar' set; correct value");

is($obj->foo, 999, '$obj->foo accessor returns expected value (still)');
is($obj->bar, 666, '$obj->bar accessor returns expected value');

is($count_foo, 1, 'builder for foo called only once');
is($count_bar, 1, 'builder for bar called only once');

