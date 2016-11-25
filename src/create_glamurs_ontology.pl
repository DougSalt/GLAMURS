
=pod

=head1 Author: Doug Salt

=head1 Date: November 2016

=head1 Version: 0.1

=head1 Name: create_glamurs_ontology.pl

=head2 Purpose

A program to take a bunch of ontologies and create an ontology from the lot of 'em. In the process of doing so, it will determine whether the 
enitity is a top or bottom ontology and create links between individuals based on the co-domain and range relationships between the parent
classes and object properties.


=head2 Parameters

=over

=back

=cut

use strict;
use warnings;

use Getopt::Long;

our $version = 0.1;

my $output;
my $ontology = "http://www.glamurs.eu/ontologies/2016/KB/glamurs";
my @library;
my @process_files;

my ($help, $reportVersion, $verbose);

my $usage = "Usage: $0 -olnpHDV --library --output-to --process-files --ontology-name --help --verbose --version path_to_ontology [, path_to_ontology]...";

die $usage unless
    GetOptions(
    		   "library|l:s" => \@library,
               "ontology-name|n:s" => \$ontology,
               "output-to|o:s" => \$output,
               "process-files|p:s" => \@process_files,
               "help|H" => \$help,
               "verbose|D" => \$verbose,
               "version|V" => \$reportVersion);
if ($help) {
	system "perldoc", "$0";
	exit 0;
}

if ($reportVersion) {
	print "Version: $version\n";
	exit 0;
}

die "No ontology name supplied"
	unless defined $ontology;
	
die "No input file supplied" unless @ARGV > 0;

my $OUTPUT;
if ( defined $output ) {
	open $OUTPUT, ">", $output
	  || die "$0: Unable to open $output: $!";
}
else {
	$OUTPUT = *STDOUT;
}

my $TOP = << "START";
Prefix(:=<$ontology#>)
Prefix(owl:=<http://www.w3.org/2002/07/owl#>)
Prefix(rdf:=<http://www.w3.org/1999/02/22-rdf-syntax-ns#>)
Prefix(xml:=<http://www.w3.org/XML/1998/namespace>)
Prefix(xsd:=<http://www.w3.org/2001/XMLSchema#>)
Prefix(rdfs:=<http://www.w3.org/2000/01/rdf-schema#>)
Prefix(star:=<http://www.glamurs.eu/ontologies/2016/TBOX/integration/star#>)
Prefix(metadata:=<http://www.glamurs.eu/ontologies/2016/KB/metadata#>)
Prefix(basic:=<http://www.glamurs.eu/ontologies/2016/TBOX/top-down/basic#>)

START

print $OUTPUT $TOP;

my $type;

my ($current_ontology, $orientation, $prefix);

for my $doc (@ARGV) {
	
	open my $INPUT, "<", $doc
	  || die "$0: Unable to open the ontology $doc: $!";
	
	while ( my $record = <$INPUT> ) {
		if ( $record =~	/^Ontology\(<(http:\/\/www\.glamurs\.eu\/ontologies\/2016\/(TBOX|ABOX|KB)\/(.*?)(\/(.*))?)>/) {
			$current_ontology = $1;
			$prefix = $5; 
			$prefix = $3 unless defined $prefix;
			print $OUTPUT "Prefix($prefix:=<$current_ontology#>)\n";
			last;

		}

	}
	
	close $INPUT;
}

print $OUTPUT "\n";
print $OUTPUT "Ontology(<$ontology>\n";
print $OUTPUT "Import(<http://www.glamurs.eu/ontologies/2016/TBOX/integration/star>)\n";

for my $doc (@ARGV) {
	
	open my $INPUT, "<", $doc
	  || die "$0: Unable to open the ontology $doc: $!";
	
	while ( my $record = <$INPUT> ) {
		if ( $record =~	/^Ontology\(<(http:\/\/www\.glamurs\.eu\/ontologies\/2016\/(TBOX|ABOX|KB)\/(.*?)(\/(.*))?)>/) {
			$current_ontology = $1;
			$prefix = $5; 
			$prefix = $3 unless defined $prefix;

			if  ($prefix =~ /^kb-/) {
				print $OUTPUT "Import(<$current_ontology>)\n";
				last;
			}
		}
	}
	close $INPUT;
}

print $OUTPUT "\n";
print $OUTPUT "Annotation(metadata:creator metadata:author:DougSalt)\n";
print $OUTPUT "\n";
	
for my $doc (@ARGV) {
	
	open my $INPUT, "<", $doc
	  || die "$0: Unable to open the ontology $doc: $!";
	
	while ( my $record = <$INPUT> ) {
		if ( $record =~	/^Ontology\(<(http:\/\/www\.glamurs\.eu\/ontologies\/2016\/(TBOX|ABOX|KB)\/(.*?)(\/(.*))?)>/) {
			$current_ontology = $1;
			$prefix = $5; 
			$prefix = $3 unless defined($prefix);
			$orientation = ucfirst($3);
			print "PREFIX = $prefix\n";
			$current_ontology =~ s/>$//;
			$orientation =~ s/\-(.)/\U$1/g;
			$orientation =~ s/^Kb//;
			print "ORIENTATION = $orientation\n";
			my $short_name = ucfirst($prefix);
			$short_name =~ s/\-(.)/\U$1/g;
			next if  ($prefix =~ /^kb-/);
			$type->{$prefix}->{"Class"} = $short_name . "OntologyClass";
			print $OUTPUT "Declaration(Class(:" . $type->{$prefix}->{"Class"} . "))\n";
			print $OUTPUT "SubClassOf(:" . $type->{$prefix}->{"Class"} . " star:" . $orientation . "OntologyClass)\n";
			print $OUTPUT "\n";
			$type->{$prefix}->{"ObjectProperty"} = "has" . $short_name . "OntologyObjectProperty";
			print $OUTPUT "Declaration(ObjectProperty(:" . $type->{$prefix}->{"ObjectProperty"} . "))\n";
			print $OUTPUT "SubObjectPropertyOf(:" . $type->{$prefix}->{"ObjectProperty"} . " star:has" . $orientation . "OntologyProperty)\n";
			print $OUTPUT "\n";
			$type->{$prefix}->{"DataProperty"} = "has" . $short_name . "OntologyDataProperty";
			print $OUTPUT "Declaration(DataProperty(:" . $type->{$prefix}->{"DataProperty"} . "))\n";
			print $OUTPUT "SubDataPropertyOf(:" . $type->{$prefix}->{"DataProperty"} . " star:has" . $orientation . "OntologyDataProperty)\n";
			print $OUTPUT "\n";
		}
		elsif (  $prefix eq "top-down-common" && $record =~ /Declaration\((Class|DataProperty|ObjectProperty)\(\:(.*)\)\)/ ){
			my $ontology_type = $1;
			my $term = $2;
			print $OUTPUT "Sub$ontology_type" . "Of($prefix:$term :" . $type->{$prefix}->{$ontology_type} . ")\n";			
		}
		elsif (  $prefix !~ /^kb-/ && $record =~ /Declaration\((Class|DataProperty|ObjectProperty)\(\:(.*)\)\)/ ){
			my $ontology_type = $1;
			my $term = $2;
			my $modded_prefix = $prefix;
 		    $modded_prefix =~ s/^/kb-/ if $modded_prefix !~ /^:/;
			print $OUTPUT "Sub$ontology_type" . "Of($prefix:$term :" . $type->{$prefix}->{$ontology_type} . ")\n";			
			print $OUTPUT "ObjectPropertyAssertion(star:hasOntologicalOrientation $modded_prefix:term:$term star:" . lcfirst($orientation) . ")\n"
				if $prefix ne "questionnaire" && $prefix ne "expert";			
			print $OUTPUT "\n";
		}			
		elsif ( $record =~ /Declaration\(NamedIndividual\(\:term\:(.*)\)\)/ ) {
			my $term = $1;
			print $OUTPUT "ClassAssertion(star:" . $orientation . "Term $prefix:term:$term)\n";
			print $OUTPUT "ObjectPropertyAssertion(star:hasOntologicalOrientation $prefix:term:$term star:" . 
				lcfirst($orientation) . ":ontology)\n";			
			print $OUTPUT "\n";			

		}
	}
	
	close $INPUT;

}

if (@library > 0) {
	for my $library (@library) {
		open my $INPUT, "<", $library
			|| die "$0: Unable to open $library: $!";
			
		while (<$INPUT>) {
				print $OUTPUT $_
		}
		close $INPUT;
	}
}

if (@process_files > 0) {
	for my $file (@process_files) {
		open my $INPUT, "<", $file
			|| die "$0: Unable to open $file: $!";
			
		while (my $record = <$INPUT>) {
				if ($record =~ /SubClassOf\((\(.*?\)\s+)?(.*?)\s+ObjectSomeValuesFrom\(star:((sigma|gamma).*?)\s+(.*)\)\)/) {
					my $range = $5;
					my $relationship = $3;
					my $domain = $2;
					$range =~ s/:/:term:/;
					$domain =~ s/:/:term:/;
					$range =~ s/^/kb-/ unless $range =~ /^:/;
					$domain =~ s/^/kb-/ unless $domain =~ /^:/;
					print "ObjectPropertyAssertion(star:$relationship $domain $range)\n";
					print $OUTPUT "ObjectPropertyAssertion(star:$relationship $domain $range)\n";
				}
		}
		close $INPUT;
	}
}

print $OUTPUT ")\n";
close $OUTPUT;
