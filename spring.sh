#!/bin/bash
json=$(curl -s -H 'Accept: application/json' https://start.spring.io)
type=$(echo "$json" | jq -r '.type.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
language=$(echo "$json" | jq -r '.language.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
packaging=$(echo "$json" | jq -r '.packaging.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
javaVersion=$(echo "$json" | jq -r '.javaVersion.values[] | "\(.name)\t\(.id)"' | fzf  --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
bootVersion=3.1.0
echo -n "group (ex. com.example): "
read -r groupId
echo -n "artifact (ex. demo): "
read -r artifactId
echo -n "name (ex. demo): "
read -r name
echo -n "description (ex. Demo project for Spring Boot): "
read -r description
description=${description// /%20}
echo -n "packageName (ex. com.example.demo): "
read -r packageName
baseDir=$name
dependencies=$(echo "$json"| jq -r '.dependencies.values[].values[] | "\(.name)\t\(.id)"' | fzf -m --delimiter='\t' --with-nth=1 | cut -f2 | awk -v d="," '{s=(NR==1?s:s d)$0}END{print s}')
URL="https://start.spring.io/starter.zip?type=$type&language=$language&bootVersion=$bootVersion&baseDir=$baseDir&groupId=$groupId&artifactId=$artifactId&name=$name&description=$description&packageName=$packageName&packaging=$packaging&javaVersion=$javaVersion&dependencies=$dependencies"

# echo "$URL"
curl -s "$URL" -o do.zip

unzip -qq do.zip
rm do.zip
