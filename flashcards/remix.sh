#!/bin/bash
TITLE=$1   
PAGES=$2  

A=1
B="$PAGES / 2 + 1"

PAGELIST=($A,$B)

x=1
while [[ $x -lt $PAGES ]]
do
  A=$A+1
PAGELIST+=($A)
B=$B+1
PAGELIST+=($B)
x=$(( $x + 2 ))
done 





echo $PAGELIST

