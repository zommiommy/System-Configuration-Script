#!/bin/bash
pdflatex -shell-escape $1

bibtex ${$1:-4}

pdflatex -shell-escape $1

pdflatex -shell-escape $1
