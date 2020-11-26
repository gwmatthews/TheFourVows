#!/bin/bash
# init
function pause(){
   read -p "$*"
}

cp sutras.sty ~/.TinyTeX/texmf-local/tex/latex/sutras/

# ...
# call it
pause 'Install successful! [Enter] ...'
texhash
# ...

