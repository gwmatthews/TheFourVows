#!/bin/bash
### IN PLACE OF A PROPER MAKEFILE rebuilds and pushes everything
MESSAGE=$1

for file in kanzeon.tex sutra-styles.tex the-four-vows.tex the-four-vows-plain.tex the-heart-sutra.tex; do xelatex $file; done


cd examples

for i in ./*.tex; do xelatex $i; done

cd ..

./clean.sh

./update.sh

cp -rv examples/*.pdf ../../github/gwmatthews.github.io.git/examples
cd flashcards
for cards in vocab-9 vocab-10 vocab-11 vocab-12 vocab-13 leeches; do ./flash.sh $cards; done
cp *.pdf ..
cd ..
cp -v *.pdf ../../github/gwmatthews.github.io.git/
git add .
git commit -m rebuild
git push
cd ../../github/gwmatthews.github.io.git/
git add .
git commit -m rebuild
git push
