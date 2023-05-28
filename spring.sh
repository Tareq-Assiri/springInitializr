#!/bin/bash
json=$(curl -s -H 'Accept: application/json' https://start.spring.io)
type=$(echo "$json" | jq -r '.type.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
language=$(echo "$json" | jq -r '.language.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
packaging=$(echo "$json" | jq -r '.packaging.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
javaVersion=$(echo "$json" | jq -r '.javaVersion.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
bootVersion=3.1.0
read -r -p "group (ex. com.example): " groupId
read -r -p "artifact (ex. demo): " artifactId
read -r -p "name (ex. demo): " name
read -r -p "description (ex. Demo project for Spring Boot): " description
description=${description// /%20}
read -r -p "packageName (ex. com.example.demo): " packageName
baseDir=$name
dependencies=$(echo "$json"| jq -r '.dependencies.values[].values[] | "\(.name)\t\(.id)"' | fzf -m --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
URL="https://start.spring.io/starter.zip?type=$type&language=$language&bootVersion=$bootVersion&baseDir=$baseDir&groupId=$groupId&artifactId=$artifactId&name=$name&description=$description&packageName=$packageName&packaging=$packaging&javaVersion=$javaVersion&dependencies=$dependencies"

echo "$URL"
curl "$URL" -o do.zip

unzip do.zip
rm do.zip
