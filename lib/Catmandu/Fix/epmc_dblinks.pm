package Catmandu::Fix::epmc_dblinks;

use Catmandu::Sane;
use Moo;

my $URL = {
	CHEMBL => 'https://www.ebi.ac.uk/chembl/target/inspect/',
	EMBL => 'http://www.ebi.ac.uk/ena/data/view/',
	UNIPROT => 'http://www.uniprot.org/uniprot/', # .html
	CHEBI => 'http://www.ebi.ac.uk/chebi/searchId.do?chId=',
	INTERPRO => 'http://www.ebi.ac.uk/interpro/entry/',
	PDB => 'http://www.ebi.ac.uk/pdbe-srv/view/entry/', # /summary
	INTACT => 'http://www.ebi.ac.uk/intact/pages/details/details.xhtml?experimentAc=',
};

my $MAP = {
    UNIPROT => {
        info1 => 'UniProt database number',
        info2 => 'Protein name',
        info3 => 'Organism',
        info4 => 'Source of the cross-reference',
        },
    EMBL => {
        info1 => 'EMBL/GenBank/DDBJ database id',
        info2 => 'Description of nucleotide sequence record',
        info3 => 'Sequence length',
        },
    PDB => {
        info1 => 'PDB database id',
        info2 => 'Experiment type',
        info3 => 'Protein structure name',
        },
    INTERPRO => {
        info1 => 'InterPro database id',
        info2 => 'Protein family/domain short name',
        info3 => 'Protein family/domain name',
        },
    OMIM => {
        info1 => 'OMIM database id',
        info2 => 'Reference number in OMIN record',
        info3 => 'Type of record',
        info4 => 'Title',
    },
    CHEBI => {
        info1 => 'ChEBI database id',
        info2 => 'Chemical Entity name',
        info3 => 'Type of record',
        },
    CHEMBL => {
        info1 => 'ChEMBL database id',
        info2 => 'Entity name or description',
        info3 => 'Type of entity',
        },
    INTACT => {
        info1 => 'IntAct database id',
        info2 => 'Experiment name',
        info3 => 'Interaction detection method',
        },
    ARXPR => {
        info1 => 'ArrayExpress accession',
        info2 => 'ArrayExpress ID',
        info3 => 'Bibliography accession',
        },
};

sub fix {
	my ($self, $data) = @_;

    my $new;
    foreach my $db (keys %$data) {
        foreach my $item ( @{ $data->{$db}->{data} } ) {
            my $tmp;
            foreach my $k (keys %$item) {
                $tmp->{$k}->{content} = $item->{$k};
                $tmp->{$k}->{label} = $MAP->{$db}->{$k} if $MAP->{$db}->{$k};
                if ($URL->{$db}) {
                  $tmp->{info5}->{label} = "URL";
                  $tmp->{info5}->{content} = $URL->{$db} . $tmp->{'info1'}->{'content'} if $tmp->{'info1'};
                  ($db eq 'UNIPROT') && ($tmp->{info5}->{content} .= '.html');
                  ($db eq 'PDB') && ($tmp->{info5}->{content} .= '/summary');
                }
            }
            push @{$new->{$db}->{data}}, $tmp;
        }
        $new->{$db}->{total} = $data->{$db}->{total};
    } 

    return $new;
}

1;

=head1 NAME

    Catmandu::Fix::epmc_dbLinks - converts the nested hash from EuropePMC in a nice form
    and provides the url to the database entry

=head1 SYNOPSIS

    use Catmandu::Fix qw(epmc_dbLinks);
    
    my $data = { ... }; 
    my $fixer = Catmandu::Fix->new(fixes => ['epmc_dbLinks()']);
    $fixer->fix($data);

=cut