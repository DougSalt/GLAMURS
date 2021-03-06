This directory contains ontologies created from the description of work and the ontologies created from text mining the GLAMURS documentation corpus. It contains two common ontologies:

+ metadata.owl - this is a common framework on which most of the top-down 
	ontologies have been built. The only top-down ontology that does not directly import this ontology is the original description of work ontology.
+ top-down.owl - this is the top-down ontology with all component ontologies from this directory 
	integrated together. This is the ontology to which all bottom-up ontologies will link.
+ integration.owl - this is the top-down ontology with all component ontologies from this directory 
	integrated together. This is the ontology to which all bottom-up ontologies will link.

The remaining parts are additional directories each containing an ontology as described below: 

+ *original description of work ontology* - This is the ontology created from the description of work at the start of the project.
+ *expert vocabulary* - This directory contains the ontology for the expert vocabulary. This is the combination of the top 200 word groups (terminology of 2 to 3 words) that have the highest combined familiarity and frequency. The familiarity in this case is defined using the corresponding property for that word in [WordNet](https://wordnet.princeton.edu/).
+ *glossary* - This directory contains an ontology listing all the terms in the initial glossary for the project that were actually used within the project. By this it is meant that some terms in the directory were not actually used through the project. This was measured by determining the frequency of the use of a given term, and if it is below a specified number then it is deemed not to be part of the project's ontology.
+ *high frequency terms* - These are the highest frequency single word terms and term of two or three words most used in the project, but not defined elsewhere. These probably represent the actual top-down ontology of the project. 
+ *on-line questionnaire* - This contains the ontology for all the responses to the on-line questionnaire not covered by the other categories listed in the top-down ontology directories. That is all the responses gathered before any directed attempt was made to obtain terminology specifically for the expert vocabulary ontology and the high frequency terms ontology. 


