use strict;
use warnings FATAL => 'all';
use Test::More;
use Test::Exception;

my $pkg;
BEGIN {
    $pkg = 'Catmandu::Importer::EuropePMC';
    use_ok $pkg;
}

require_ok $pkg;

use Catmandu::Importer::EuropePMC;

dies_ok { my $imp = $pkg->new(module => "databaseLinks", page => 1) };

lives_ok { my $imp = $pkg->new(query => "10779411") };

my $importer = $pkg->new(query => '10779411');

isa_ok($importer, $pkg);

can_ok($importer, 'each');

can_ok($importer, 'count');

my $rec = $importer->first->{resultList}->{result};

like($rec->{title}, qr/^Structural basis/, "title ok");
is($rec->{pmid}, '10779411', "pmid ok");

lives_ok { my $db_imp = $pkg->new(
		query => '10779411', 
		module => 'databaseLinks',
		db => 'uniprot',
		page => '1',
		) };

my $db_importer = $pkg->new(
		query => '10779411', 
		module => 'databaseLinks',
		db => 'uniprot',
		page => '1',
		);

my $db = $db_importer->first;

is(exists $db->{dbCrossReferenceList}->{dbCrossReference}, '1', "Database links ok");

my $db_importer2 = $pkg->new(
	query => '23280342', 
	module => 'databaseLinks',
	db => 'uniprot',
	page => '1',
	);

my $db2 = $db_importer2->first;
is(exists $db2->{dbCrossReferenceList}->{dbCrossReference}, '1', "More Database links ok");

done_testing 12;
