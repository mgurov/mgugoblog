#!/bin/bash -eux

M=${1:-'-'}
PUBLISH_DST=../blog

git status
git add .
git commit -m ${M}
git push origin

hugo
cp -R ./public/ ${PUBLISH_DST}

cd ${PUBLISH_DST}
pwd
git status
git add .
git commit -m ${M}
git push origin HEAD:master