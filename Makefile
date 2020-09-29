CONTRIBUTION  = $(shell basename ${PWD})
NAME          = Martin Scharrer
EMAIL         = martin@scharrer.me
DIRECTORY     = /macros/latex/contrib/${CONTRIBUTION}
LICENSE       = free
FREEVERSION   = lppl
CTAN_FILE     = ${CONTRIBUTION}.zip
export CONTRIBUTION VERSION NAME EMAIL SUMMARY DIRECTORY DONOTANNOUNCE ANNOUNCE NOTES LICENSE FREEVERSION CTAN_FILE


MAINDTX       = ${CONTRIBUTION}.dtx
DTXFILES      = ${MAINDTX}
INSFILES      = ${CONTRIBUTION}.ins
LTXFILES      = ${CONTRIBUTION}.cls ${CONTRIBUTION}.sty ${CONTRIBUTION}.cfg
LTXDOCFILES   = ${CONTRIBUTION}.pdf README
LTXSRCFILES   = ${DTXFILES} ${INSFILES}
PLAINFILES    = ${CONTRIBUTION}.tex
PLAINDOCFILES = #${CONTRIBUTION}.?
PLAINSRCFILES = #${CONTRIBUTION}.?
GENERICFILES  = #${CONTRIBUTION}.tex
GENDOCFILES   = #${CONTRIBUTION}.?
GENSRCFILES   = #${CONTRIBUTION}.?
SCRIPTFILES   = #${CONTRIBTUION}.pl
SCRDOCFILES   = #${CONTRIBUTION}.?
ALLFILES      = ${DTXFILES} ${INSFILES} ${LTXFILES} ${LTXDOCFILES} ${LTXSRCFILES} \
				${PLAINFILES} ${PLAINDOCFILES} ${PLAINSRCFILES} \
				${GENERICFILES} ${GENDOCFILES} ${GENSRCFILES} \
				${SCRIPTFILES} ${SCRDOCFILES}
MAINFILES     = ${DTXFILES} ${INSFILES} ${LTXFILES}
CTANFILES     = ${DTXFILES} ${INSFILES} ${LTXDOCFILES} ${PLAINDOCFILES} ${GENDOCFILES} ${SCRDOCFILES}

TDSZIP      = ${CONTRIBUTION}.tds.zip

TEXMF       = ${HOME}/texmf
LTXDIR      = ${TEXMF}/tex/latex/${CONTRIBUTION}/
LTXDOCDIR   = ${TEXMF}/doc/latex/${CONTRIBUTION}/
LTXSRCDIR   = ${TEXMF}/source/latex/${CONTRIBUTION}/
GENERICDIR  = ${TEXMF}/tex/generic/${CONTRIBUTION}/
GENDOCDIR   = ${TEXMF}/doc/generic/${CONTRIBUTION}/
GENSRCDIR   = ${TEXMF}/source/generic/${CONTRIBUTION}/
PLAINDIR    = ${TEXMF}/tex/plain/${CONTRIBUTION}/
PLAINDOCDIR = ${TEXMF}/doc/plain/${CONTRIBUTION}/
PLAINSRCDIR = ${TEXMF}/source/plain/${CONTRIBUTION}/
SCRIPTDIR   = ${TEXMF}/scripts/${CONTRIBUTION}/
SCRDOCDIR   = ${TEXMF}/doc/support/${CONTRIBUTION}/

TDSDIR   = tds
TDSFILES = ${LTXFILES} ${LTXDOCFILES} ${LTXSRCFILES} \
		   ${PLAINFILES} ${PLAINDOCFILES} ${PLAINSRCFILES} \
		   ${GENERICFILES} ${GENDOCFILES} ${GENSRCFILES} \
		   ${SCRIPTFILES} ${SCRDOCFILES}

BUILDDIR = build

LATEXMK  = latexmk -quiet -pdf
ZIP      = zip -r
WEBBROWSER = firefox
GETVERSION = $(strip $(shell grep '=\*VERSION' -A1 ${MAINDTX} | tail -n1))

AUXEXTS  = .aux .bbl .blg .cod .exa .fdb_latexmk .glo .gls .lof .log .lot .out .pdf .que .run.xml .sta .stp .svn .svt .toc
CLEANFILES = $(addprefix ${CONTRIBUTION}, ${AUXEXTS})

.PHONY: all doc clean distclean

all: doc

doc: ${CONTRIBUTION}.pdf

${CONTRIBUTION}.pdf: ${DTXFILES} README ${INSFILES} ${LTXFILES}
	${MAKE} --no-print-directory build
	cp "${BUILDDIR}/$@" "$@"

ifneq (${BUILDDIR},build)
build: ${BUILDDIR}
endif

${BUILDDIR}: ${MAINFILES}
	-mkdir ${BUILDDIR} 2>/dev/null || true
	cp ${MAINFILES} README ${BUILDDIR}/
	$(foreach DTX,${DTXFILES}, tex '\input ydocincl\relax\includefiles{${DTX}}{${BUILDDIR}/${DTX}}' && rm -f ydocincl.log;)
	cd ${BUILDDIR}; $(foreach INS, ${INSFILES}, tex ${INS};)
	cd ${BUILDDIR}; $(foreach DTX, ${MAINDTX}, ${LATEXMK} ${DTX};)
	touch ${BUILDDIR}

$(addprefix ${BUILDDIR}/,$(sort ${TDSFILES} ${CTANFILES})): ${MAINFILES}
	${MAKE} --no-print-directory build

clean:
	latexmk -C ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r ${BUILDDIR} ${TDSDIR} ${TDSZIP} ${CTAN_FILE}


distclean:
	latexmk -c ${CONTRIBUTION}.dtx
	${RM} ${CLEANFILES}
	${RM} -r ${BUILDDIR} ${TDSDIR}


install: $(addprefix ${BUILDDIR}/,${TDSFILES})
ifneq ($(strip $(LTXFILES)),)
	test -d "${LTXDIR}" || mkdir -p "${LTXDIR}"
	cd ${BUILDDIR} && cp ${LTXFILES} "$(abspath ${LTXDIR})"
endif
ifneq ($(strip $(LTXSRCFILES)),)
	test -d "${LTXSRCDIR}" || mkdir -p "${LTXSRCDIR}"
	cd ${BUILDDIR} && cp ${LTXSRCFILES} "$(abspath ${LTXSRCDIR})"
endif
ifneq ($(strip $(LTXDOCFILES)),)
	test -d "${LTXDOCDIR}" || mkdir -p "${LTXDOCDIR}"
	cd ${BUILDDIR} && cp ${LTXDOCFILES} "$(abspath ${LTXDOCDIR})"
endif
ifneq ($(strip $(GENERICFILES)),)
	test -d "${GENERICDIR}" || mkdir -p "${GENERICDIR}"
	cd ${BUILDDIR} && cp ${GENERICFILES} "$(abspath ${GENERICDIR})"
endif
ifneq ($(strip $(GENSRCFILES)),)
	test -d "${GENSRCDIR}" || mkdir -p "${GENSRCDIR}"
	cd ${BUILDDIR} && cp ${GENSRCFILES} "$(abspath ${GENSRCDIR})"
endif
ifneq ($(strip $(GENDOCFILES)),)
	test -d "${GENDOCDIR}" || mkdir -p "${GENDOCDIR}"
	cd ${BUILDDIR} && cp ${GENDOCFILES} "$(abspath ${GENDOCDIR})"
endif
ifneq ($(strip $(PLAINFILES)),)
	test -d "${PLAINDIR}" || mkdir -p "${PLAINDIR}"
	cd ${BUILDDIR} && cp ${PLAINFILES} "$(abspath ${PLAINDIR})"
endif
ifneq ($(strip $(PLAINSRCFILES)),)
	test -d "${PLAINSRCDIR}" || mkdir -p "${PLAINSRCDIR}"
	cd ${BUILDDIR} && cp ${PLAINSRCFILES} "$(abspath ${PLAINSRCDIR})"
endif
ifneq ($(strip $(PLAINDOCFILES)),)
	test -d "${PLAINDOCDIR}" || mkdir -p "${PLAINDOCDIR}"
	cd ${BUILDDIR} && cp ${PLAINDOCFILES} "$(abspath ${PLAINDOCDIR})"
endif
ifneq ($(strip $(SCRIPTFILES)),)
	test -d "${SCRIPTDIR}" || mkdir -p "${SCRIPTDIR}"
	cd ${BUILDDIR} && cp ${SCRIPTFILES} "$(abspath ${SCRIPTDIR})"
endif
ifneq ($(strip $(SCRDOCFILES)),)
	test -d "${SCRDOCDIR}" || mkdir -p "${SCRDOCDIR}"
	cd ${BUILDDIR} && cp ${SCRDOCFILES} "$(abspath ${SCRDOCDIR})"
endif
	touch ${TEXMF}
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true


installsymlinks:
	test -d "${LTXDIR}" || mkdir -p "${LTXDIR}"
	-cd ${LTXDIR} && ${RM} ${LTXFILES}
	ln -s $(abspath ${LTXFILES}) ${LTXDIR}
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true


uninstall:
	${RM} -rf ${LTXDIR} ${LTXDOCDIR} ${LTXSRCDIR} \
		${GENERICDIR} ${GENDOCDIR} ${GENSRCDIR} \
		${PLAINDIR} ${PLAINDOCDIR} ${PLAINSRCDIR} \
		${SCRIPTDIR} ${SCRDOCDIR}
	-test -f ${TEXMF}/ls-R && texhash ${TEXMF} || true


ifneq (${TDSDIR},tdsdir)
tdsdir: ${TDSDIR}
endif
${TDSDIR}: $(addprefix ${BUILDDIR}/,${TDSFILES})
	${MAKE} --no-print-directory install TEXMF=${TDSDIR}

tdszip: ${TDSZIP}

${TDSZIP}: ${TDSDIR}
	-${RM} $@
	cd ${TDSDIR} && ${ZIP} $(abspath $@) *

zip: ${CTAN_FILE}

${CTAN_FILE}: $(addprefix ${BUILDDIR}/,${CTANFILES})
	-rm -rf ${CONTRIBUTION}/
	mkdir ${CONTRIBUTION}/
	cp $(addprefix ${BUILDDIR}/,${CTANFILES}) ${CONTRIBUTION}/
	-${RM} $@
	${ZIP} $@ ${CONTRIBUTION}

upload: VERSION = ${GETVERSION}

upload: ${CTAN_FILE}
	ctanupload -p

webupload: VERSION = ${GETVERSION}
webupload: ${CTAN_FILE}
	${WEBBROWSER} 'http://dante.ctan.org/upload.html?contribution=${CONTRIBUTION}&version=${VERSION}&name=${NAME}&email=${EMAIL}&summary=${SUMMARY}&directory=${DIRECTORY}&DoNotAnnounce=${DONOTANNOUNCE}&announce=${ANNOUNCEMENT}&notes=${NOTES}&license=${LICENSE}&freeversion=${FREEVERSION}' &


