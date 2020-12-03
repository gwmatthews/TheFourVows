#!/bin/bash
SET=$1                                            ## takes one argument filename of csv file minus the .csv
BEGINFRONT=$(sed -n '1,4 p' < card-frame)         ## LaTeX at beginning of front pages
BEGINBACK=$(sed -n '5,8 p' < card-frame)          ## LaTeX at beginning of back pages
END=$(sed -n '9,11 p' < card-frame)               ## LaTeX at end of file

## fill content into front of card: wrap comma separated fields in braces, add prefix, divide into sections, same for back

FRONT=$(cat $SET.csv | sed -e 's_Unavailable_{radical_'| sed -e 's/["]/{/' -e 's/[",]./}{/' -e 's/[,"]./}{/' -e 's/"/}/' | sed 's/{/\\flashFront{/' | sed -f spacing.sed| sed '/3/ a\\\RLmulticolcolumns')
BACK=$(cat $SET.csv | sed -e 's_Unavailable_{radical_'| sed -e 's/["]/{/' -e 's/[",]./}{/' -e 's/[,"]./}{/' -e 's/"/}/' | sed 's/{/\\flashBack{/' | sed -f spacing.sed| sed '/3/ a\\\LRmulticolcolumns')

## add front and back of card LaTeX wrappers

echo "$BEGINFRONT" "$FRONT" "$END" > $1-cards-front.tex
echo "$BEGINBACK" "$BACK" "$END"  > $1-cards-back.tex

## duplicate the cards template

cp cards.tex $1-cards.tex

## compile cards

xelatex $1-cards.tex

## clean up the mess

rm ./*.aux
rm ./*.log
rm ./*.out
rm $SET-cards*.tex


