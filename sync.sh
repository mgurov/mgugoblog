#!/bin/bash -eux

M=${1:-'-'}
PUBLISH_DST=../mgurov.github.io

git status
git add .
git commit -m "${M}" || echo 'ok, was nothing to commit?'
git push origin

hugo
cp -R ./public/ ${PUBLISH_DST}

cd ${PUBLISH_DST}
pwd
git status
git add .
git commit -m "${M}"
git push origin HEAD:master