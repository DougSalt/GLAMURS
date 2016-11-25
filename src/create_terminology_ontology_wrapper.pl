=pod

=head1 Author: Doug Salt

=head1 Date: November 2016

=head1 Version: 0.1

=head1 Name: create_terminology_ontology_wrapper.pl

=head2 Purpose

A program to take an ontological entity instantiate it as an individual and then
refer to as the kind of entity it is, where an entity is one of the primary
divisions in an OWL ontology. That it is one of a class, object property or
data property. Depending on parameters this will be instantated as a top-down
ontological type of property, or a bottom-up ontological property.

=head2 Parameters

=over

=back

=cut

use strict;
use warnings;

use Getopt::Long;

our $version = 0.1;

my $output;
my $ontology_short_name;
my $top_down_ontology;
my ($import_ontology, $import_ontology_short_name);
my $extant_individuals;
my ( $help, $reportVersion, $verbose );

my $usage =
"Usage: $0 -inosHDTV --import-ontology --import-ontology-short-name --output-to --ontology-short-name --help --top-down-ontology --help --verbose --version ontology_path_name";

die $usage
  unless GetOptions(
	"import-ontology|i:s"	  => \$import_ontology,
	"import-ontology-short-name|n:s"
							  => \$import_ontology_short_name,
	"output-to|o:s"           => \$output,
	"ontology-short-name|s:s" => \$ontology_short_name,
	"top-down-ontology|T"     => \$top_down_ontology,
	"help|H"                  => \$help,
	"verbose|D"               => \$verbose,
	"version|V"               => \$reportVersion
  );


if ($help) {
    system "perldoc", "$0";
    exit 0;
}

if ($reportVersion) {
    print "Version: $version\n";
    exit 0;
}

die "No input file supplied" unless @ARGV > 0;
die "Only one input file allowed (for now)" unless @ARGV == 1;

die "Need to define a short name for the import ontology"
	if defined $import_ontology && not defined $import_ontology_short_name;
	
my $orientation = $top_down_ontology ? "top-down" : "bottom-up";

open my $INPUT, "<", $ARGV[0] ||
        die "$0: Unable to open the ontology $ARGV[0]: $!";


my $OUTPUT;
if (defined $output) {
        open $OUTPUT, ">", $output ||
                die "$0: Unable to open $output: $!";
}
else {
        $OUTPUT = *STDOUT;
}

my ($ontology, $new_ontology);
my %entities;
my %extant;

while (my $record = <$INPUT>) {
        if ($record =~ /^Ontology\(<(http:\/\/www\.glamurs\.eu\/ontologies\/2016\/(TBOX|ABOX)\/(.*?)(\/(.*))?)>$/) {
                $ontology = $1;
                warn "Ontology type is $3, whereas parameters says $orientation"
                        if (defined($3) && $3 ne $orientation) ;
                $ontology_short_name = $5 unless defined $ontology_short_name;
                $ontology =~ s/>$//;
                $new_ontology = $ontology;
                $new_ontology  =~ s/(TBOX|ABOX)/KB/;
                $new_ontology  =~ s/$ontology_short_name/kb-$ontology_short_name/;
                #print "Ontology = $ontology\n";
                #print "My short name = $ontology_short_name\n";
        }
        elsif ($record =~ /Declaration\((Class|DataProperty|ObjectProperty)\(\:(.*)\)\)/) {
                my $entity_type = lc($1);
                next if $entity_type =~ /^owl\:/;
                my $entity = $2;
                next if $entity =~ /^owl\:/;
				$entities{$entity} = $entity_type;
        }
	    elsif ($record =~ /Declaration\(NamedIndividual\(\:term\:(.*)\)\)/) {
	    		$extant{$1} = 1;
	    }

}

close $INPUT;

my $TOP = << "START";
Prefix(:=<$new_ontology#>)
Prefix(owl:=<http://www.w3.org/2002/07/owl#>)
Prefix(rdf:=<http://www.w3.org/1999/02/22-rdf-syntax-ns#>)
Prefix(xml:=<http://www.w3.org/XML/1998/namespace>)
Prefix(xsd:=<http://www.w3.org/2001/XMLSchema#>)
Prefix(rdfs:=<http://www.w3.org/2000/01/rdf-schema#>)
Prefix(metadata:=<http://www.glamurs.eu/ontologies/2016/KB/metadata#>)
Prefix($ontology_short_name:=<$ontology#>)
START
print $OUTPUT $TOP;

if (defined $import_ontology) {
	$ontology = $import_ontology;
	print "Prefix($import_ontology_short_name:=<$import_ontology#>)\n";
}

my $ONT = << "BODY";

Ontology(<$new_ontology>
Import(<http://www.glamurs.eu/ontologies/2016/KB/metadata>)
Import(<$ontology>)

Annotation(metadata:creator metadata:author:DougSalt)

BODY
print $OUTPUT $ONT;

for my $entity (keys %entities) {
				my $entity_type = $entities{$entity};
                if ($extant{$entity}) {
                	print $OUTPUT "AnnotationAssertion(metadata:describes $ontology_short_name:term:$entity $ontology_short_name:$entity)\n";
                	print $OUTPUT "ObjectPropertyAssertion(metadata:isOntologicalEntity $ontology_short_name:term:$entity metadata:ontology:$entity_type)\n";
                } else { 
                	print $OUTPUT "Declaration(NamedIndividual(:term:$entity))\n";
                	print $OUTPUT "AnnotationAssertion(metadata:describes :term:$entity $ontology_short_name:$entity)\n";
                	print $OUTPUT "ClassAssertion(metadata:Term :term:$entity)\n";
                	print $OUTPUT "ObjectPropertyAssertion(metadata:isOntologicalEntity :term:$entity metadata:ontology:$entity_type)\n";
                	print $OUTPUT "AnnotationAssertion(rdfs:seeAlso $ontology_short_name:$entity :term:$entity)\n";
                }
                print $OUTPUT "\n";

}
print $OUTPUT ")\n";

close $OUTPUT;
