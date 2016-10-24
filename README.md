# GLAMURS ONTOLOGIES

This is the repository for all ontologies created during the [GLAMURS project](http://glamurs.eu/).

Essentially this site is a set of directories containing ontologies. Each leaf directory contains a one or two ontologies and common roots contain any imported ontologies common to those leaf ontologies, or alternatively a integration of the ontologies present in those leaf directories.

Note that many of these ontologies in are TBox only (or TBox sparsely populated with anonymous data). This has been done in order to protect any referenced participants privacy.

The directory structure is the following:

+ **docs**
	This contains all documentation used to enhance this presence in github. The main project web page is here along with style sheets and images need to render the page.
+ **bottom-up ontologies** - This contains all the ontologies created for each major deliverable of the project. These can be listed into the following categories. Each category corresponds to a directory.
	- *back-casting* - This is the ontology for back-casting workshops
	- *environmental footprinting* - This directory contains the populated model describing the footprinting ontology used by NTNU to determined integrated assessments of several facets of enviromental impact on a region by region basis.
	- *initiative interviews* - This is the directory containing the ontology for regional initiative interviews
	- *models* - this is the directory containing the three differing kinds of models shown below.
	    * agent-based models - There are several agent based models (ABM), but at the moment this only contains the ontology for the TiPaC ABM.
	    * micro-economic models - This directory contains a single ontology for all four types of the University of Bath's micro-economic moodels.
	    * macro-economic models - This directory contains two ontologies so far. These are two variations on the Tilburg University's macro-economic model.
	- *regional surveys* - This is the directory containing the ontologies for the regional survey questionnaire to assess and evaluate people attitudes to changes to a sustainable lifestyle. There are different ontologies for differing parts of Europe and the sustainable targets being assessed were different.
		* rest of Europe - This is the directory containing the ontology for the the regional survey questionnaire to assess and evaluate people's attitudes to changes to a sustainable lifestyle for European regions: Spain, Netherlands, Germany, Austria, Italy and Romania.
		* Scotland - This is the directory containing the ontology for the the regional survey questionnaire to assess and evaluate people's attitudes to changes to a sustainable lifestyle for European region of Scotland.
	- *social network analysis* - This ontology was used to elicit and define the important social networks involved in the successful implementation of the sustainble initiatives which were examined for each region of the project.
		* rest of Europe - This was the ontological framework used to defined the important social networks for the sustainability initiatives for European regions: Spain, Netherlands, Germany, Austria, Italy and Romania.
		* Scotland - This was the ontology created to defined the social network used in affecting or affecting those involved in the sustainability initiative in the Scotland case-study region. This initiative was different from the other European regionally initiatives in that it was primarily an issue in determining governance. 
	+ *UKHLS* - This is the UK Household Longitudinal Survey; a large survey that has been continued for several decades. This survey represents an unsolicited and very rich source of environmental data on attitudes and practices in the UK (unsolicited in that it was not designed specifically for GLAMURS).
+ **top-down ontologies** - This contains ontologies created from the description of work and the ontologies created from text mining the GLAMURS documentation corpus.
	- *original description of work ontology* - This is the ontology created from the description of work at the start of the project.
	- *expert vocabulary* - This directory contains the ontology for the expert vocabulary. This is the combination of the top 200 word groups (terminology of 2 to 3 words) that have the highest combined familiarity and frequency. The familiarity in this case is defined using the corresponding property for that word in [WordNet](https://wordnet.princeton.edu/).
	- *glossary* - This directory contains an ontology listing all the terms in the initial glossary for the project that were actually used within the project. By this it is meant that some terms in the directory were not actually used through the project. This was measured by determining the frequency of the use of a given term, and if it is below a specified number then it is deemed not to be part of the project's ontology.
	- *high frequency terms* - These are the highest frequency single word terms and term of two or three words most used in the project, but not defined elsewhere. These probably represent the actual top-down ontology of the project. 
	- *on-line questionnaire* - This contains the ontology for all the responses to the on-line questionnaire not covered by the other categories listed in the top-down ontology directories. That is all the responses gathered before any directed attempt was made to obtain terminology specifically for the expert vocabulary ontology and the high frequency terms ontology. 
	
+ **integration ontology** - This directory contains all the ontologies linking the other ontologies together and the linking vocabulary ontologies themselves. This contains the two integration vocabularies. These are divided into the top-down ontology to the bottom-up ontology vocabulary, and conversely bottom-up to the top-down ontology vocabulary ontology. This has been done to allow the specification of directional axioms. In particular, this may be used to enforce the star network pattern on the overall ontology by enforcing axioms the ensure all linkages should happen via the top-down ontology. For this reason the bottom-up to down-ontology must include the top-down to bottom-up ontology, and hence the nested directory, used for the reasons made explicit at the top of this note. Hence this directory has one further sub-division, itself containing one additional direcotry for each of these vocabularies the upper including the lower.
	- *bottom-up to to-down vocabulary* - Contains the bottom-up to top-down vocabulary ontology.
		* top-down to bottom-up vocabulary - Contains the simple top-down to bottom-up vocabulary ontology. 