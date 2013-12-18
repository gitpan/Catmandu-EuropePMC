use strict;
use warnings;
use Test::More;

my $pkg;
BEGIN {
    $pkg = 'Catmandu::Importer::EuropePMC';
    use_ok $pkg;
}

require_ok $pkg;

my $importer = Catmandu::Importer::EuropePMC->new(query => '10779411');

isa_ok($importer, $pkg);

can_ok($importer, 'each');

done_testing 4;
