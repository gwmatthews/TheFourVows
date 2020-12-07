#!/bin/bash
###  generates Japanese flashcards from csv files produced by Wanikani Item Inspector
###  building cards requires sutras.sty LaTeX package
#
function usage {

echo "$0 <filename> <optional fontsize in pts>" 

}

if [ $# -lt 1 ]; then
	    usage
	  	exit 1 # error
fi
#
## takes one argument filename of csv file with or without .csv extension
FILENAME=$1
#
## set default font size: can be changed with optional second parameter 30 is good for longer vocab, 55 is good for single kanji
#
FSIZE=${2:-30}                                                             
FONTSIZE="\renewcommand{\smallkanji}{\centering\fontsize{$FSIZE}{$FSIZE}}"
SET="${FILENAME%.[^.]*}" 
#
## get LaTeX wrappers from card-frame file
#                 
BEGINFRONT=$(sed -n '2,4 p' < card-frame)
BEGINBACK=$(sed -n '5,8 p' < card-frame)
END=$(sed -n '9,11 p' < card-frame)
#
## fill content into front of card: wrap comma separated fields in braces, add prefix, divide into sections, same for back
#
FRONT=$(cat $SET.csv | sed -e 's_Unavailable_{radical_'| sed -e 's/["]/{/' -e 's/[",]./}{/' -e 's/[,"]./}{/' -e 's/"/}/' | sed 's/{/\\flashFront{/' | sed -f spacing.sed| sed '/3/ a\\\RLmulticolcolumns')
BACK=$(cat $SET.csv | sed -e 's_Unavailable_{radical_'| sed -e 's/["]/{/' -e 's/[",]./}{/' -e 's/[,"]./}{/' -e 's/"/}/' | sed 's/{/\\flashBack{/' | sed -f spacing.sed| sed '/3/ a\\\LRmulticolcolumns')
#
## add front and back of card LaTeX wrappers
#
echo "$FONTSIZE" $'\n' "$BEGINFRONT" "$FRONT" "$END" > $SET-cards-front.tex
echo "$FONTSIZE" $'\n' "$BEGINBACK" "$BACK" "$END"  > $SET-cards-back.tex
#
## duplicate the cards template
#
cp cards $SET-cards.tex
#
## create temp pdf sheets to be reshuffled and rebuilt in code that follows
#
xelatex $SET-cards.tex
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
cp remix $SET.tex                                                 
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
xelatex $SET                                                     
#
## clean up the mess
#
rm ./*.aux
rm ./*.log
rm ./*.out
rm *.tex
rm *-cards.pdf


