TEXMF=${HOME}/texmf
INSTALLDIR=${TEXMF}/tex/latex/standalone
DOCINSTALLDIR=${TEXMF}/doc/latex/standalone
CP=cp
RMDIR=rm -rf
PDFLATEX=pdflatex -interaction=batchmode
LATEXMK=latexmk -pdf -silent

PACKEDFILES=standalone.cls standalone.sty standalone.cfg standalone.tex
DOCFILES=standalone.pdf
SRCFILES=standalone.dtx README Makefile


RED   = \033[01;31m
GREEN = \033[01;32m
BOLD  = \033[01m
NORMAL = \033[00m

OK = ${GREEN}OK${NORMAL}
FAIL = ${RED}FAILURE${NORMAL}

all: unpack doc

package: unpack
class: unpack

unpack: ${PACKEDFILES}

${PACKEDFILES}: standalone.dtx
	${PDFLATEX} -draftmode -interaction=nonstopmode '\def\endinstall{\endgroup\csname @enddocumenthook\endcsname\csname @@end\endcsname}\input{standalone.ins}' || (${RM} standalone.aux; false)


# 'doc' and 'standalone.pdf' call itself until everything is stable
doc: standalone.pdf
	@${MAKE} --no-print-directory standalone.pdf

once: standalone.dtx
	pdflatex $<
	-readacro standalone.pdf

twice: standalone.dtx
	${PDFLATEX} $<
	${PDFLATEX} '\let\install\iffalse\let\endinstall\fi\input{$<}'
	-readacro standalone.pdf

pdfopt: doc
	@-pdfopt standalone.pdf .temp.pdf && mv .temp.pdf standalone.pdf

standalone.pdf: standalone.dtx
	${PDFLATEX} $<
	${PDFLATEX} '\let\install\iffalse\let\endinstall\fi\input{$<}'
	-makeindex -s gind.ist -o "$@" "$<"
	-makeindex -s gglo.ist -o "$@" "$<"
	${PDFLATEX} '\let\install\iffalse\let\endinstall\fi\input{$<}'
	${PDFLATEX} '\let\install\iffalse\let\endinstall\fi\input{$<}'

.PHONY: test

test: unpack
	@cd test; for T in test*.tex; do echo "-------------------------------------------------------------"; echo "${BOLD}$$T${NORMAL}"; pdflatex -interaction=batchmode $$T && echo "${OK}" || echo "${FAIL}"; done

clean:
	-latexmk -C standalone.dtx
	${RM} ${PACKEDFILES} *.zip *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo *.gls *.hd *.sta *.stp *.cod
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

dtx: standalone.dtx

standalone.dtx: standalone.ins standalone_doc.dtx standalone_sty.dtx standalone_cls.dtx standalone_tex.dtx standalone_cfg.dtx
	@echo Creating $@
	@cat $^ | perl -ne 'if (/^(\s*\\DocInput)/) { if (!$$n++) { print "$${1}{standalone.dtx}\n"; } } else { print }' > $@
	@echo '% \Finale' >> $@
	@echo '% \endinput' >> $@

