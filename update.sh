#!/bin/bash

version="2022.1"
patch=$(curl -s -L 'https://github.com/sndyx/rpg-pack/blob/master/patch?raw=true')
rm patch
echo $((1+patch)) >> patch
version+="."$((1+patch))

rm pack.mcmeta
echo "{\"pack\": {\"pack_format\": 9,\"description\":\"Edition $version\"}}" >> pack.mcmeta

ls
./zip.sh
git add .
git commit -m "Update to $version"
git push