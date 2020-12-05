#!/bin/bash
###  generates Japanese flashcards from csv files produced by Wanikani Item Inspector
###  EXAMPLE ./flash.sh vocab-20   (using file vocab-20.csv)
### options -h: print help, -k: kanji only use larger font

FONTSIZE="\renewcommand{\smallkanji}{\centering\fontsize{34}{34}}"

SET=$1                                                               ## takes one argument filename of csv file minus the .csv
BEGINFRONT=$(sed -n '1,3 p' < card-frame)                             ## LaTeX at beginning of front pages
BEGINBACK=$(sed -n '4,7 p' < card-frame)                              ## LaTeX at beginning of back pages
END=$(sed -n '8,10 p' < card-frame)                                   ## LaTeX at end of cards file
#
## fill content into front of card: wrap comma separated fields in braces, add prefix, divide into sections, same for back
#
FRONT=$(cat $SET.csv | sed -e 's_Unavailable_{radical_'| sed -e 's/["]/{/' -e 's/[",]./}{/' -e 's/[,"]./}{/' -e 's/"/}/' | sed 's/{/\\flashFront{/' | sed -f spacing.sed| sed '/3/ a\\\RLmulticolcolumns')
BACK=$(cat $SET.csv | sed -e 's_Unavailable_{radical_'| sed -e 's/["]/{/' -e 's/[",]./}{/' -e 's/[,"]./}{/' -e 's/"/}/' | sed 's/{/\\flashBack{/' | sed -f spacing.sed| sed '/3/ a\\\LRmulticolcolumns')
#
## add front and back of card LaTeX wrappers
#
echo "$FONTSIZE" "$BEGINFRONT" "$FRONT" "$END" > $1-cards-front.tex
echo "$FONTSIZE" "$BEGINBACK" "$BACK" "$END"  > $1-cards-back.tex
#
## duplicate the cards template
#
cp cards.tex $1-cards.tex
#
## create temp pdf sheets to be reshuffled and rebuilt in code that follows
#
xelatex $1-cards.tex
#
## reshuffle pages for two sided printing
#
## initialize variables
#
PAGES=$(pdfinfo $SET-cards.pdf | grep "Pages" | awk '{print $NF}')    ## Extract number of pages in cards file                                                                           
REVERSE=$(( PAGES / 2 ))
OUTPUT=pagelist.tex                                                   ## For building reshuffled page set
NUM=0
#
## copy the template
#
cp remix.tex $SET.tex                                                 
#
## construct the pagelist array
#
arr=()                                                                
for ((i=1; i<=$REVERSE; i++)); do
    NUM=$i
	arr+=("$NUM" )
    NUM=$(( REVERSE + i))
    arr+=("$NUM" )
done
#
##### format for pdfpages
#
PAGELIST=$(echo ${arr[@]} | sed 's/\s/, /g')                          
#
## assemble full line of LaTeX code
#
REORDERED="\includepdf[pages={${PAGELIST}}, delta=0 0, offset=0 0]{$SET-cards.pdf}"   
#
## export as pagelist.tex
#
echo $REORDERED > $OUTPUT                                             
#
## compile reordered flashcard pages
#
xelatex $SET.tex                                                     
#
## clean up the mess
#
rm ./*.aux
rm ./*.log
rm ./*.out
#rm $SET-cards*.tex
#rm $SET-cards.pdf



