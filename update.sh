#!/bin/bash

version="2022.1"
patch=$(curl -L 'https://github.com/sndyx/rpg-pack/blob/master/patch?raw=true')
echo $patch >> patch
version+="."$((1+patch))

./zip
git add .
git commit -m "Update to $version"
git push