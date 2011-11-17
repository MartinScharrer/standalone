%
% \iffalse
%<*cls>
%<!COPYRIGHT>
% \fi
%
% \subsection{The Class File}
%    \begin{macrocode}
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{standalone}[%
%<!DATE>
%<!VERSION>
%<*DRIVER>
    2099/01/01 develop
%</DRIVER>
    Class to compile TeX sub-files standalone]
%    \end{macrocode}
%
% \subsubsection{If-Switches}
%
% \begin{macro}{\ifstandalone}
% This if-switch is defined by both the class and package. This class sets
% it to true while the package (loaded by the main document) sets it to false.
%    \begin{macrocode}
\newif\ifstandalone
\standalonetrue
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\ifstandalonebeamer}
% This if-switch is defined by both the class and package. This class sets
% it to true only if the |beamer| option was given. The package (loaded by the main document) sets it always to false.
%    \begin{macrocode}
\newif\ifstandalonebeamer
\standalonebeamerfalse
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\onlyifstandalone}
% Macro version of |\ifstandalone|. The |{ }| around the argument protects the content from the package etc. scanners.
%    \begin{macrocode}
\let\onlyifstandalone\@firstofone
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\notifstandalone}
% Negated form of |\notifstandalone|.
%    \begin{macrocode}
\let\notifstandalone\@gobble
%    \end{macrocode}
% \end{macro}
%
%
% \subsubsection{Options}
%
%    \begin{macrocode}
\RequirePackage{ifpdf}
\RequirePackage{pgfopts}
\pgfkeys{/standalone/cls/.is family}
%    \end{macrocode}
%
% Use of |preview| package is optional but enabled by default.
% This defines the |\ifsa@preview| switch.
%    \begin{macrocode}
\newif\ifsa@preview
\pgfkeys{/standalone/cls/.cd,
   preview/.is if=sa@preview,
   preview/.default=true,
   preview=true,
}
%    \end{macrocode}
%
%
%    \begin{macrocode}
\newif\ifsa@box
\pgfkeys{/standalone/cls/.cd,
   box/.is if=sa@box,
   box/.default=true,
   box=true,
}
%    \end{macrocode}
%
%
%    \begin{macrocode}
\newif\ifsa@varwidth
\pgfkeys{/standalone/cls/.cd,
   varwidth/.is if=sa@varwidth,
   varwidth/.default=true,
   varwidth=true,
}
%    \end{macrocode}
%
% To set the preview border:
%    \begin{macrocode}
\pgfkeys{/standalone/cls/.cd,
   border/.store in=\sa@border,
   border/.value required,
}
\let\sa@border\relax
%    \end{macrocode}
%
% Enable beamer support.
%    \begin{macrocode}
\pgfkeys{/standalone/cls/.cd,
  beamer/.code={%
    \def\sa@class{beamer}%
    \sa@previewfalse
    \standalonebeamertrue
  },
  beamer/.value forbidden,
}
%    \end{macrocode}
%
% Option to set underlying class. Default is |article|.
%    \begin{macrocode}
\pgfkeys{/standalone/cls/.cd,
   class/.store in=\sa@class,
   class/.value required,
   class=article,
}
%    \end{macrocode}
%
% \begin{macro}{\standaloneconfig}
%    \begin{macrocode}
\newcommand*{\standaloneconfig}{\pgfqkeys{/standalone}}
%    \end{macrocode}
% \end{macro}
%
%    \begin{macrocode}
\newif\ifsa@convert
\pgfkeys{/standalone/cls/.cd,
  convert/.style={/standalone/cls/convert/.cd,true,#1},
  convert/.unknown/.style={/errors/unknown choice value=\pgfkeyscurrentkey\pgfkeyscurrentvalue},
  convert/.default=true,
%
  png/.@cmd/.link=/standalone/cls/convert/png/.@cmd,
  png72/.@cmd/.link=/standalone/cls/convert/png72/.@cmd,
  png150/.@cmd/.link=/standalone/cls/convert/png150/.@cmd,
  png300/.@cmd/.link=/standalone/cls/convert/png300/.@cmd,
  jpg/.@cmd/.link=/standalone/cls/convert/jpg/.@cmd,
  gif/.@cmd/.link=/standalone/cls/convert/gif/.@cmd,
%
  convert/.cd,
  png/.style={/standalone/cls/convert/.cd,true,outext={.png},#1},
  png72/.style={/standalone/cls/convert/.cd,true,outext={.png},density=72,#1},
  png150/.style={/standalone/cls/convert/.cd,true,outext={.png},density=150,#1},
  png300/.style={/standalone/cls/convert/.cd,true,outext={.png},density=300,#1},
  jpg/.style={/standalone/cls/convert/.cd,true,outext={.jpg},#1},
  gif/.style={/standalone/cls/convert/.cd,true,outext={.gif},#1},
%
  true/.code={\sa@converttrue},
  false/.code={\sa@convertfalse},
  false,
%
  newer/.code={\def\sa@convert@newer{\filemodCmp{\outfile}{\jobname}}},%
  force/.code={\let\sa@convert@newer\@secondoftwo},
  newer,
%
  command/.initial={},
  imagemagick/.style={/standalone/cls/convert/command={\convertexe\space -density \density\space \infile\space \ifx\size\empty\else -resize \size\fi\space -quality 90 \outfile}},
  ghostscript/.style={/standalone/cls/convert/command={gs -dSAFER -dBATCH -dNOPAUSE -sDEVICE=\gsdevice\space -r\density\space -sOutputFile=\outfile\space \infile}},
  gs/.@cmd/.link=/standalone/cls/convert/ghostscript/.@cmd,
  gsdevice/ext.jpg/.initial={jpg},
  gsdevice/ext.png/.initial={png16m},
  gsdevice/.initial={\pgfkeysifdefined{/standalone/cls/convert/gsdevice/ext\outext}{\pgfkeysvalueof{/standalone/cls/convert/gsdevice/ext\outext}}{\expandafter\@gobble\outext}},
  convertexe/.initial={imgconvert},
  density/.initial={300},
  size/.initial={},
  inext/.initial={\ifpdf.pdf\else.ps\fi},
  precommand/.initial={\ifpdf\else dvips \jobname \fi},
  inname/.initial={\jobname},
  infile/.initial={\inname\inext},
  outext/.initial={.png},
  outname/.initial={\inname},
  outfile/.initial={\outname\outext},
  imagemagick,
%
  onfailure/.is choice,
  onfailure/error/.code={\let\sa@convert@failuremsg\ClassError},
  onfailure/warning/.code={\let\sa@convert@failuremsg\ClassWarning},
  onfailure/info/.code={\let\sa@convert@failuremsg\ClassInfo},
  onfailure/ignore/.code={\def\sa@convert@failuremsg{\expandafter\@gobbletwo\@gobble}\let\sa@convert@notfoundmsg\@gobbletwo},
  onfailure=warning,
}
\let\sa@convert@notfoundmsg\ClassWarning
\IfFileExists{/usr/bin/convert}{%
    \standaloneconfig{cls/convert/convertexe={convert}}%
}{%
\IfFileExists{/usr/local/bin/convert}{%
    \standaloneconfig{cls/convert/convertexe={convert}}%
}{}%
}
%    \end{macrocode}
%
% \begin{environment}{standalone}
% The \env{standalone} environment is defined by default to be without effect.
% The \cs{endstandalone} macro is set to |\relax|, so a redefinition with
% \cs{renewenvironment} in the configuration file is possible and also can later be detected.
%    \begin{macrocode}
\let\standalone\empty
\let\endstandalone\relax
%    \end{macrocode}
% \end{environment}
%
% Load configuration file.
%    \begin{macrocode}
\input{standalone.cfg}
%    \end{macrocode}
%
%
% The rest of the options are accumulated and set as the official class options
% for the real class loaded afterwards. This avoids the passing of any |standalone| class options
% to the underlying class in any way. The |beamer| class for example has an option called
% `|class|' in a similar way the |standalone| class does, which would cause problems if not filtered out.
%    \begin{macrocode}
\def\sa@classoptionslist{}
\pgfkeys{/standalone/cls/.unknown/.code={%
  \xdef\sa@classoptionslist{\sa@classoptionslist,\pgfkeyscurrentname}%
}}
\ProcessPgfOptions{/standalone/cls}
\let\@classoptionslist\sa@classoptionslist
%    \end{macrocode}
%
% Loads the class given by the |class| option with the rest of the options.
%    \begin{macrocode}
\begingroup
\xdef\@tempa{[\sa@classoptionslist]{\sa@class}}
\expandafter
\endgroup
\expandafter\LoadClass\@tempa
%    \end{macrocode}
%
% \subsubsection{Preview Code}
% The \env{standalone} environment is redefined to use the |preview| environment as
% long it was not redefined in the configuration file.
%    \begin{macrocode}
\ifsa@preview
  \@ifundefined{endstandalone}{%
    \ifsa@varwidth
    \renewenvironment{standalone}
      {\preview\varwidth{\linewidth}}
      {\endvarwidth\endpreview}
    \else
    \renewenvironment{standalone}
      {\preview   }
      {\endpreview}
    \fi
  }{}%
  \RequirePackage{preview}
  \ifsa@varwidth
    \RequirePackage{varwidth}
  \fi
%    \end{macrocode}
% Read the preview border values. The default unit is |bp| (PostScript points).
% Allowed are one, two or four values.
%    \begin{macrocode}
  \ifx\sa@border\relax\else
    \begingroup
    \def\rem@bp#1bp\relax#2\@nnil{#1}%
    \def\default@bp#1{\expandafter\rem@bp\the\dimexpr#1 bp\relax bp\relax\@nnil}%
    \def\sa@readborder#1 #2 #3 #4 {%
       \ifx\\#2#3#4\\%
         \@defaultunits\global\PreviewBorder=\dimexpr#1 bp\relax\@nnil%
       \else
       \ifx\\#4\\%
        \xdef\PreviewBbAdjust{-\default@bp{#1} -\default@bp{#2} \default@bp{#1} \default@bp{#2}}%
       \else
        \xdef\PreviewBbAdjust{-\default@bp{#1} -\default@bp{#2} \default@bp{#3} \default@bp{#4}}%
       \fi\fi
    }%
    \@firstofone{\expandafter\sa@readborder\sa@border} {} {} {} {} \relax
    \endgroup
  \fi
\fi
%    \end{macrocode}
%
%
% \subsubsection{Preview Code}
% The \env{standalone} environment is redefined to use the |preview| environment as
% long it was not redefined in the configuration file.
%    \begin{macrocode}
\ifsa@box
  \newbox\sa@box
  \pagestyle{empty}
  \hoffset=-72.27pt
  \voffset=-72.27pt
  \topmargin=0pt
  \headheight=0pt
  \headsep=0pt
  \marginparsep=0pt
  \marginparwidth=0pt
  \footskip=0pt
  \marginparpush=0pt
  \oddsidemargin=0pt
  \evensidemargin=0pt
  \@ifundefined{endstandalone}{%
    \ifsa@varwidth
    \renewenvironment{standalone}
      {\setbox\sa@box\hbox\bgroup\color@setgroup\varwidth{\linewidth}}
      {\endvarwidth\color@endgroup\egroup\sa@handlebox}
    \else
    \renewenvironment{standalone}
      {\setbox\sa@box\hbox\bgroup\color@setgroup}
      {\color@endgroup\egroup\sa@handlebox}
    \fi
  }{}%
  \ifsa@varwidth
    \RequirePackage{varwidth}
  \fi
%    \end{macrocode}
% Read the preview border values. The default unit is |bp| (PostScript points).
% Allowed are one, two or four values.
%    \begin{macrocode}
  \ifx\sa@border\relax\else
    \begingroup
    \def\rem@bp#1bp\relax#2\@nnil{#1}%
    \def\default@bp#1{\expandafter\rem@bp\the\dimexpr#1 bp\relax bp\relax\@nnil}%
    \def\sa@readborder#1 #2 #3 #4 {%
       \ifx\\#2#3#4\\%
         \@defaultunits\global\PreviewBorder=\dimexpr#1 bp\relax\@nnil%
       \else
       \ifx\\#4\\%
        \xdef\PreviewBbAdjust{-\default@bp{#1} -\default@bp{#2} \default@bp{#1} \default@bp{#2}}%
       \else
        \xdef\PreviewBbAdjust{-\default@bp{#1} -\default@bp{#2} \default@bp{#3} \default@bp{#4}}%
       \fi\fi
    }%
    \@firstofone{\expandafter\sa@readborder\sa@border} {} {} {} {} \relax
    \endgroup
  \fi

\def\sa@handlebox{%
    \sbox\sa@box{\raise\dp\sa@box\box\sa@box}%
    \pdfpageheight=\ht\sa@box
    \pdfpagewidth=\wd\sa@box
    \noindent\usebox\sa@box
}

\fi
%    \end{macrocode}
%
%
% \subsubsection{Converting}
%    \begin{macrocode}
\ifsa@convert
  \RequirePackage{filemod-expmin}
  \begingroup
  \def\sa@convert#1{%
      \edef\filemodbefore{\csname pdffilemoddate\endcsname{\outfile}}%
      \immediate\write18{\sa@convertcommand}%
      \IfFileExists{\outfile}{%
          \edef\filemodafter{\csname pdffilemoddate\endcsname{\outfile}}%
          \ifx\filemodbefore\filemodafter
              \expandafter\ifx\csname pdffilemoddate\endcsname\relax\else
                  \sa@convert@failuremsg{standalone}{#1}{}%
              \fi
          \else
              \message{^^Jstandalone: Conversion successfull.^^J}%
          \fi
      }{%
          \sa@convert@failuremsg{standalone}{#1}{}%
      }%
  }
  \pgfkeys{/standalone/cls/convert/.cd,
        infile/.get=\infile,
        inext/.get=\inext,
        inname/.get=\inname,%
        gsdevice/.get=\gsdevice,%
        convertexe/.get=\convertexe,%
        density/.get=\density,%
        size/.get=\size,%
        outext/.get=\outext,%
        outname/.get=\outname,%
        outfile/.get=\outfile,%
        command/.get=\sa@convertcommand,%
        precommand/.get=\sa@preconvertcommand,
  }%
  \edef\sa@preconvertcommand{\sa@preconvertcommand}%
  \ifx\sa@preconvertcommand\empty\else
    \immediate\write18{\sa@preconvertcommand}%
  \fi
  \IfFileExists{\infile}{%
    \sa@convert@newer
    {%
        \message{^^Jstandalone: Skipped conversion: outfile newer than main file.^^J}%
    }{%
    \ifcase0%
        \expandafter\ifx\csname pdfshellescape\endcsname\relax
        \ifeof18 \else 3\fi
        \else\the\pdfshellescape\fi
    \relax% 0
        \sa@convert@failuremsg
            {standalone}{Shell escape disabled! Cannot convert file '\infile'.}{}%
    \or% 1  % ok
        \sa@convert{Conversion unsuccessful!^^JThere might be something wrong with your conversation software or the file^^Jpermissions!}%
    \else% 2 or 3
        \sa@convert{Conversion failed! Please ensure that shell escape is enabled (e.g. use '-shell-escape').}%
    \fi
    }%
  }{%
    \sa@convert@notfoundmsg
        {standalone}{Cannot convert missing input file '\infile'.}%
  }%
  \endgroup
\fi
%    \end{macrocode}
%
% \subsubsection{Beamer Frame Environment}
%
%    \begin{macrocode}
\ifstandalonebeamer
%    \end{macrocode}
% \begin{environment}{standaloneframe}
% Front-end for the beamer |frame| environment. Parses all arguments
% the same way and calls it with an added option.
%    \begin{macrocode}
\newenvironment{standaloneframe}{%
  \@ifnextchar<%
    {\@standaloneframe}%
    {\@@standaloneframe{}}%
}{\end{frame}}%
\def\@standaloneframe<#1>{%
    \@@standaloneframe{<#1>}%
}
\def\@@standaloneframe#1{%
  \@ifnextchar[%]
    {\@@@standaloneframe{#1}}%
    {\@@@standaloneframe{#1}[]}%
}%
\def\@@@standaloneframe#1[{%
  \@ifnextchar<%
    {\@@@@standaloneframe{#1}[}%
    {\@@@@@@standaloneframe{#1}[}%
}%
\def\@@@@standaloneframe#1[#2]{%
  \@ifnextchar[%]
    {\@@@@@standaloneframe{#1}{#2}}%
    {\begin{frame}#1[#2][environment=standaloneframe]}%
}%
\def\@@@@@standaloneframe#1#2[#3]{%
    \begin{frame}#1[#2][environment=standaloneframe,#3]%
}%
\def\@@@@@@standaloneframe#1[#2]{%
    \begin{frame}#1[environment=standaloneframe,#2]%
}%
%    \end{macrocode}
% \end{environment}
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
% \subsubsection{Document Environment in Sub-Files}
%
%
% \begin{environment}{document}
% Adds own `after begin document' and `before end document` hooks.
%    \begin{macrocode}
\begingroup

\toks@\expandafter{%
    \document
    \let\documentclass\sa@documentclass  % TODO: really required?
    \sa@cls@afterbegindocument
}
\xdef\document{\the\toks@}%

\toks@\expandafter{%
    \expandafter
    \sa@cls@beforeenddocument
    \enddocument
}
\xdef\enddocument{\the\toks@}%
\endgroup
%    \end{macrocode}
% \end{environment}
%
%
% \begin{macro}{\sa@cls@afterbegindocument}
% \begin{macro}{\sa@cls@beforeenddocument}
% Hooks which add the \env{standalone} environment. Surrounding spaces
% are removed. This hooks are used (instead of calling the content directly in the above macros)
% to add the possibility to fine tune this later, e.g.\ in the configuration file.
%    \begin{macrocode}
\def\sa@cls@afterbegindocument{\expandafter\standalone\ignorespaces}
\def\sa@cls@beforeenddocument{\ifhmode\unskip\fi\endstandalone}
%    \end{macrocode}
% \end{macro}
% \end{macro}
%
% \iffalse
%</cls>
% \fi
%
