all: unpack doc

unpack: standalone.dtx standalone.ins
	yes | pdflatex standalone.ins

doc: standalone.pdf

standalone.pdf: standalone.dtx
	latexmk -pdf $<

.PHONY: test

test:
	for T in test*.tex; do pdflatex -interaction=batchmode $$T && echo "OK" || echo "Failure"; done

clean:
	${RM} standalone.cfg standalone.tex standalone.sty standalone.cls *.log *.aux *.toc *.vrb *.nav *.pdf *.snm *.out *.fdb_latexmk *.glo

