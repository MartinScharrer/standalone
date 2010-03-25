TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/standalone
DOCINSTALLDIR=${TEXMF}/doc/latex/standalone
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode

PACKEDFILES=standalone.cls standalone.sty standalone.cfg standalone.tex
DOCFILES=standalone.pdf
SRCFILES=standalone.dtx standalone.ins README Makefile

all: unpack doc

package: unpack
class: unpack

${PACKEDFILES}: ${SRCFILES}
	yes | pdflatex standalone.ins

unpack: ${PACKEDFILES}

doc: ${DOCFILES}

standalone.pdf: %.pdf: standalone.dtx
	${PDFLATEX} $<
	${PDFLATEX} $<
	-makeindex -s gind.ist -o $*.ind $*.idx
	-makeindex -s gglo.ist -o $*.gls $*.glo
	${PDFLATEX} $<
	${PDFLATEX} $<

.PHONY: test

test: unpack
	for T in test*.tex; do echo "$$T"; pdflatex -interaction=batchmode $$T && echo "OK" || echo "Failure"; done

clean:
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.sta *.stp
	${RMDIR} .tds

install: unpack doc ${INSTALLDIR} ${DOCINSTALLDIR}
	${CP} ${PACKEDFILES} ${INSTALLDIR}
	${CP} ${DOCFILES} ${DOCINSTALLDIR}
	texhash ${TEXMF}

${INSTALLDIR}:
	mkdir -p $@

${DOCINSTALLDIR}:
	mkdir -p $@

ctanify: ${SRCFILES} ${DOCFILES} standalone.tds.zip
	${RM} standalone.zip
	zip standalone.zip $^ 
	unzip -t standalone.zip
	unzip -t standalone.tds.zip

zip: standalone.zip

tdszip: standalone.tds.zip

standalone.zip: ${SRCFILES} ${DOCFILES}
	${RM} $@
	zip $@ $^ 

standalone.tds.zip: ${SRCFILES} ${PACKEDFILES} ${DOCFILES} 
	${RMDIR} .tds
	mkdir -p .tds/tex/latex/standalone
	mkdir -p .tds/doc/latex/standalone
	mkdir -p .tds/source/latex/standalone
	${CP} ${DOCFILES}    .tds/doc/latex/standalone
	${CP} ${PACKEDFILES} .tds/tex/latex/standalone
	${CP} ${SRCFILES}    .tds/source/latex/standalone
	cd .tds; zip -r ../$@ .
	${RMDIR} .tds

