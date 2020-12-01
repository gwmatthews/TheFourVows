#!/bin/bash

MESSAGE=$1

for file in kanzeon.tex leech-cards.tex sutra-styles.tex the-four-vows.tex the-four-vows-plain.tex the-heart-sutra.tex; do xelatex $file; done


cd examples

for i in ./*.tex; do xelatex $i; done

cd ..

./clean.sh

./update.sh

git add .
git commit -m MESSAGE
git push
cp -rv examples/*.pdf ../../github/gwmatthews.github.io.git/examples
cp -v *.pdf ../../github/gwmatthews.github.io.git/

cd ../../github/gwmatthews.github.io.git/
git add .
git commit -m MESSAGE
git push
