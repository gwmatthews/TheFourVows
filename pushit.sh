#!/bin/bash

MESSAGE=$1

git add .
git commit -m MESSAGE
git push
cp -rv examples/*.pdf ../../github/gwmatthews.github.io.git/
cp -v *.pdf ../../github/gwmatthews.github.io.git/

cd ../../github/gwmatthews.github.io.git/
git add .
git commit -m MESSAGE
git push
