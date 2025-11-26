#!/usr/bin/env bash

workdir=$1
cd ${workdir}/Magisk
release_tag=$(git rev-parse HEAD | cut -c 1-8)
ver=$(grep "magisk.versionCode" app/gradle.properties | awk -F "=" '{print $2}')
echo "## Magisk (${release_tag}) (${ver})" > ${workdir}/out/notes.md
json=$(curl -sL -H 'Authorization: token ${{ secrets.GITHUB_TOKEN }}' https://api.github.com/repos/topjohnwu/Magisk/commits | jq .)
jsha=$(echo $json | jq .[].sha | sed 's/\"//g')
hsha=$(curl -sL -H 'Authorization: token ${{ secrets.GITHUB_TOKEN }}' https://api.github.com/repos/hubbylei/Magisk-Files/commits | jq .[0].commit.message | sed 's/\"//g' | awk -F "-" '{print $1}')
sha=()
i=0
for s in $jsha
do
  sha[$i]=$(echo $s | cut -c 1-8)
  i=$(($i+1))
done
for ((i=0;i <${#sha[@]};i++))
do
  if [ ${sha[$i]} == $hsha ];then
      break
  fi
  echo "- "$(echo $json | jq .[$i].commit.message | sed 's/\\n/<br>/g' | sed 's/\"//g') >> ${workdir}/out/notes.md
done
