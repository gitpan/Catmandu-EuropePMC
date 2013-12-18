package Catmandu::Fix::epmc_filter;

use Catmandu::Sane;
use Moo;

sub fix {
	my ($self, $rec) = @_;
  
  if ($rec->{resultList}) {
    my $hash = $rec->{resultList}->{result};
    my $data;
    foreach my $f (qw(pmid pmcid hasReferences citedByCount
        hasDbCrossReferences dbCrossReferenceList hasTextMinedTerms 
        hasReferences inEPMC inPMC)) {
        if (ref $hash eq 'HASH' && defined $hash->{$f}) {
          $data->{$f} = $hash->{$f};
        }
    }

    $data->{citedByCount} = $data->{citedByCount} ||= 0;

    return $data;
  } else {
    return {};
  }

}

1;

=head1 Catmandu:Fix:epmc_filter

    Catmandu::Fix::epmc_filter - extract basic fields from EuropePMC

=head1 SYNOPSIS

  use Catmandu::Fix qw(epmc_filter);
  use Catmandu::Importer::EBI;
  
  my $importer = Catmandu::Importer::EuropePMC->new(query => 'doi:...');
    
  my $fixer = Catmandu::Fix->new(fixes => ['epmc_filter()']);

=cut