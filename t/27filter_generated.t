use strict;
use File::Slurp qw(slurp);
use File::Path;
use Test::More tests => 4;
use Test::Exception;
use lib qw(t/lib);
use make_dbictest_db;
use dbixcsl_test_dir qw/$tdir/;

use DBIx::Class::Schema::Loader;

my $dump_path = "$tdir/dump";

my %original_class_data;

{
    package DBICTest::Schema::1;
    use base qw/ DBIx::Class::Schema::Loader /;
    __PACKAGE__->loader_options(
        dump_directory => $dump_path,
        filter_generated_text => sub {
            my ($class, $text) = @_;
            $original_class_data{$class} = $text;
	    if ($class =~ /::1$/) {
                $text = "No Gotcha!";
	    }
            else {
	        $text .= q{"Kilroy was here";};
	    }
            return $text;
        },
    );
}

DBICTest::Schema::1->connect($make_dbictest_db::dsn);

my $foo = slurp("$dump_path/DBICTest/Schema/1/Result/Foo.pm");
ok(! -e "$dump_path/DBICTest/Schema/1.pm",
     "No package means no file written");
ok($original_class_data{"DBICTest::Schema::1"},
     "Even though we processed the missing class");
like($foo, qr/# Created by .* THE FIRST PART/s,
     "We get the whole autogenerated text");
like($foo, qr/Kilroy was here/, "Can insert text");

END { rmtree($dump_path, 1, 1); }