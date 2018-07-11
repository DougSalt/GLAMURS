#!/bin/sh

head -1 glamurs.owl
grep ^Ontology glamurs.owl
sed '$ d' glamurs.owl \
    | perl -pe "s/(\(|\s)[^\s\(\^]*?(?<!(dfs|owl|xsd)):/\1:/g" \
    | egrep -v "^Import" \
    | egrep -v "^Prefix" \
    | egrep -v "^Ontology" 

find . -name "*.owl"| while read ontology 
do
    if [[ "$ontology" = *glamurs.owl ]] \
    || [[ "$ontology" = *rules.owl ]] 
    then
        (>&2 echo "found a file: $ontology")
        continue
    fi
        (>&2 echo "processing: $ontology")
    sed '$ d' "$ontology" \
        | perl -pe "s/(\(|\s)[^\s\(\^]*?(?<!(dfs|owl|xsd)):/\1:/g" \
        | egrep -v "^Import" \
        | egrep -v "^Prefix" \
        | egrep -v "^Ontology" \
        | perl -ne "/^(Annotation\((.|\n)*\)\s*)$/m"
done

echo ")"
