TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/standalone
DOCINSTALLDIR=${TEXMF}/doc/latex/standalone
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode
LATEXMK=latexmk -pdf -silent

PACKEDFILES=standalone.cls standalone.sty standalone.cfg standalone.tex gincltex.sty
DOCFILES=standalone.pdf gincltex.pdf
SRCFILES=standalone.dtx standalone.ins gincltex.dtx gincltex.ins README Makefile

all: unpack doc

package: unpack
class: unpack

${PACKEDFILES}: standalone.dtx standalone.ins gincltex.dtx gincltex.ins 
	yes | pdflatex standalone.ins
	yes | pdflatex gincltex.ins

unpack: ${PACKEDFILES}

# 'doc' and 'standalone.pdf' call itself until everything is stable
doc: standalone.pdf gincltex.pdf
	@${MAKE} --no-print-directory standalone.pdf

pdfopt: doc
	@-pdfopt standalone.pdf .temp.pdf && mv .temp.pdf standalone.pdf

%.pdf: %.dtx
	${PDFLATEX} $<
	-makeindex -s gind.ist -o "$@" "$<"
	-makeindex -s gglo.ist -o "$@" "$<"
	${PDFLATEX} $<
	${PDFLATEX} $<


.PHONY: test

test: unpack
	for T in test*.tex; do echo "$$T"; pdflatex -interaction=batchmode $$T && echo "OK" || echo "Failure"; done

clean:
	-latexmk -C standalone.dtx
	-latexmk -C gincltex.dtx
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.gls *.hd *.sta *.stp
	${RMDIR} tds

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

standalone.zip: ${SRCFILES} ${DOCFILES} | pdfopt
	${RM} $@
	zip $@ $^ 

standalone.tds.zip: ${SRCFILES} ${PACKEDFILES} ${DOCFILES} | pdfopt
	${RMDIR} tds
	mkdir -p tds/tex/latex/standalone
	mkdir -p tds/doc/latex/standalone
	mkdir -p tds/source/latex/standalone
	${CP} ${DOCFILES}    tds/doc/latex/standalone
	${CP} ${PACKEDFILES} tds/tex/latex/standalone
	${CP} ${SRCFILES}    tds/source/latex/standalone
	cd tds; zip -r ../$@ .

