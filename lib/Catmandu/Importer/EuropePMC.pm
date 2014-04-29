package Catmandu::Importer::EuropePMC;

use Catmandu::Sane;
use XML::LibXML::Simple qw(XMLin);
use Try::Tiny;
use Furl;
use Moo;

with 'Catmandu::Importer';

use constant BASE_URL => 'http://www.ebi.ac.uk/europepmc/webservices/rest';

has base => (is => 'ro', default => sub { return BASE_URL; });
has source => (is => 'ro', default => sub { return "MED"; });
has query => (is => 'ro', required => 1);
has module => (is => 'ro', default => sub { return "search"; });
has db => (is => 'ro');
has page => (is => 'ro');
has format => (is => 'ro');

my %MAP = (references => 'reference',
  citations => 'citation',
  dbCrossReferenceInfo => 'dbCrossReference');

sub _request {
  my ($self, $url) = @_;

  my $ua = Furl->new(timeout => 20);

  my $res;
  try {
    $res = $ua->get($url);
    die $res->status_line unless $res->is_success;

    return $res->content;
  } catch {
    Catmandu::Error->throw("Status code: $res->status_line");
  };

}

sub _hashify {
  my ($self, $in) = @_;

  my $xs = XML::LibXML::Simple->new();
  my $field = $MAP{$self->module};
  my $out = $xs->XMLin($in);

  return $out;
}

sub _call {
  my ($self) = @_;

  my $url = $self->base;
  if ($self->module eq 'search') {
    $url .= '/search/query=' . $self->query;
  } else {
    $url .= '/'. $self->source .'/'. $self->query .'/'. $self->module;
    $url .= '/'. $self->db if $self->db;
    $url .= '/'. $self->page if $self->page;
  }

  my $res = $self->_request($url);

  return $res;
}

sub _get_record {
  my ($self) = @_;
  
  my $xml = $self->_call;
  my $hash = $self->_hashify($xml);
    
  return $hash;
}

sub generator {

  my ($self) = @_;

  return sub {
    $self->_get_record;
  };

}

1;

=head1 NAME

  Catmandu::Importer::EuropePMC - Package that imports EuropePMC data.

=head1 API Documentation

  This module uses the REST service as described at http://www.ebi.ac.uk/europepmc/.

=head1 SYNOPSIS

  use Catmandu::Importer::EuropePMC;

  my %attrs = (
    source => 'MED',
    query => 'malaria',
    module => 'search',
    db => 'EMBL',
    page => '2',
  );

  my $importer = Catmandu::Importer::EuropePMC->new(%attrs);

  my $n = $importer->each(sub {
    my $hashref = $_[0];
    # ...
  });

=head1 OPTIONS

=over

=item * source: default is 'MED'

=item * query: required

=item * module: default is 'search', other possible values are 'databaseLinks', 'citations', 'references'

=item * db: the name of the database. Use when module is 'databaseLinks'

=item * page: the paging parameter

=item * format: default is 'xml', the other choice is 'json'

=back

=head1 SEE ALSO

L<Catmandu::Iterable>, L<Catmandu::Importer::PubMed>

=cut
