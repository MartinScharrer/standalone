all: unpack doc

unpack: standalone.dtx standalone.ins
	yes | pdflatex standalone.ins

package: unpack
class: unpack

doc: standalone.pdf

standalone.pdf: standalone.dtx
	latexmk -pdf $<

.PHONY: test

test: unpack
	for T in test*.tex; do echo "$$T"; pdflatex -interaction=batchmode $$T && echo "OK" || echo "Failure"; done

clean:
	${RM} standalone.cfg standalone.tex standalone.sty standalone.cls *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo


ctanify: 
	ctanify standalone.dtx standalone.ins README Makefile

zip: standalone.zip

standalone.zip: standalone.dtx standalone.ins README Makefile standalone.pdf
	${RM} $@
	zip $@ $^ 

