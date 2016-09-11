# Makefile for latex

TARGET = proposal.tex

all : pdf dvi bib

pdf: ${TARGET}
	pdflatex ${TARGET}


dvi: ${TARGET}
	latex ${TARGET}

bib: ${TARGET}
	bibtex ${TARGET}
clean:
	rm -f *.aux *.lof *.lot *.out *.toc *.log *.dvi
	rm **~
