#!/bin/bash    
SET=$1                                                                ### takes single argument -- filename without extenstion
PAGES=$(pdfinfo $SET-cards.pdf | grep "Pages" | awk '{print $NF}')    ### Extract number of paages in card file                                                                           
REVERSE=$(( PAGES / 2 ))

OUTPUT=pagelist.tex                                                   ### what this script does is generate a snippet of LaTeX code to be inserted into the document template
NUM=0
cp remix.tex $SET.tex                                                 ### copy the template

arr=()                                                                ### construct the pagelist array
for ((i=1; i<=$REVERSE; i++)); do
    NUM=$i
	arr+=("$NUM" )
    NUM=$(( REVERSE + i))
    arr+=("$NUM" )
done
PAGELIST=$(echo ${arr[@]} | sed 's/\s/, /g')                          ### format for pdfpages

REORDERED="\includepdf[pages={${PAGELIST}}, delta=0 0, offset=0 0]{$SET-cards.pdf}"  ### assemble full line of LaTeX code 

echo $REORDERED > $OUTPUT                                             ### export as pagelist.tex

xelatex $SET.tex                                                      ### compile reordered flashcard pages


#### NOW INTEGRATED into flash.sh keeping in case it is needed elsewhere



