TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/standalone
DOCINSTALLDIR=${TEXMF}/doc/latex/standalone
CP=cp
RMDIR=rm -rf

PACKEDFILES=standalone.cls standalone.sty standalone.cfg standalone.tex
DOCFILES=standalone.pdf
SRCFILES=standalone.dtx standalone.ins README Makefile

all: unpack doc

unpack: standalone.dtx standalone.ins
	yes | pdflatex standalone.ins

package: unpack
class: unpack

doc: ${DOCFILES}

standalone.pdf: standalone.dtx
	latexmk -pdf $< || ${MAKE} nolatexmk

nolatexmk: standalone.dtx
	pdflatex $<
	pdflatex $<

.PHONY: test

test: unpack
	for T in test*.tex; do echo "$$T"; pdflatex -interaction=batchmode $$T && echo "OK" || echo "Failure"; done

clean:
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo
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

standalone.tds.zip: ${SRCFILES} ${DOCFILES} ${PACKEDFILES}
	${RMDIR} .tds
	mkdir -p .tds/tex/latex/standalone
	mkdir -p .tds/doc/latex/standalone
	mkdir -p .tds/source/latex/standalone
	${CP} ${DOCFILES}    .tds/doc/latex/standalone
	${CP} ${PACKEDFILES} .tds/tex/latex/standalone
	${CP} ${SRCFILES}    .tds/source/latex/standalone
	cd .tds; zip -r ../$@ .
	${RMDIR} .tds

