#!/usr/bin/env bash

workdir=$1
cd ${workdir}/Magisk
release_tag=$(git rev-parse HEAD | cut -c 1-8)
ver=$(grep "magisk.versionCode" app/gradle.properties | awk -F "=" '{print $2}')
echo "## Magisk (${release_tag}) (${ver})" > ${workdir}/out/notes.md
json=$(curl -sL https://api.github.com/repos/topjohnwu/Magisk/commits)
jsha=$(echo $json | jq -r .[].sha)
hsha=$(curl -sL https://api.github.com/repos/hubbylei/Magisk-Files/commits | jq -r .[0].commit.message | awk -F "-" '{print $1}')
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
  message=$(echo $json | jq .[$i].commit.message)
  echo ${message}
  echo "- ${message}" | sed 's/\"//g' | sed 's/\\n/<br>/g' >> ${workdir}/out/notes.md
done
