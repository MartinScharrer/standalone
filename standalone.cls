%
% \subsection{The Class File}
%    \begin{macrocode}
%<!COPYRIGHT>
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
% \begin{macro}{\IfStandalone}[2]{true clause}{false clause}
% Macro version of |\ifstandalone .. \else .. \fi|. The |{ }| around the argument protects the content from the package etc. scanners.
%    \begin{macrocode}
\let\IfStandalone\@firstoftwo
%    \end{macrocode}
% \end{macro}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Code for border values}
% The following macros are used to parse the \opt{border} option.
%
% \begin{macro}{\sa@border@left}
% \begin{macro}{\sa@border@right}
% \begin{macro}{\sa@border@top}
% \begin{macro}{\sa@border@margin}
%    \begin{macrocode}
\def\sa@border@left{0.50001bp}
\let\sa@border@right\sa@border@left
\let\sa@border@top\sa@border@left
\let\sa@border@bottom\sa@border@left
%    \end{macrocode}
% \end{macro}
% \end{macro}
% \end{macro}
% \end{macro}
%
%
% \begin{macro}{\rem@bp}
%    \begin{macrocode}
\def\rem@bp#1bp\relax#2\@nnil{#1}%
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\default@bp}
%    \begin{macrocode}
\def\default@bp#1#2{%
    \begingroup
    \afterassignment\remove@to@nnil
    \dimen@ #2bp\relax\@nnil
    \expandafter
    \endgroup
    \expandafter
    \def\expandafter#1\expandafter{\the\dimen@}%
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@readborder}
%    \begin{macrocode}
\def\sa@readborder#1 #2 #3 #4 #5\@nnil{%
    \ifx\\#2#3#4\\%
        \default@bp\sa@border@left{#1}%
        \let\sa@border@right\sa@border@left
        \let\sa@border@top\sa@border@left
        \let\sa@border@bottom\sa@border@left
    \else
    \ifx\\#4\\%
        \default@bp\sa@border@left{#1}%
        \let\sa@border@right\sa@border@left
        \default@bp\sa@border@top{#2}%
        \let\sa@border@bottom\sa@border@top
    \else
        \default@bp\sa@border@left{#1}%
        \default@bp\sa@border@bottom{#2}%
        \default@bp\sa@border@right{#3}%
        \default@bp\sa@border@top{#4}%
    \fi\fi
}%
%    \end{macrocode}
% \end{macro}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Options}
%
%    \begin{macrocode}
\let\sa@classoptionslist\@classoptionslist
\RequirePackage{xkeyval}
\newif\ifsa@preview
\newif\ifsa@crop
\newif\ifsa@varwidth
\newif\ifsa@ignorerest
\newif\ifsa@tikz
%    \end{macrocode}
%
% The \cs{ifstandalonebeamer} switch is in the user-level.
% Wire the setter macros to the internal naming scheme, so that \Macro\sa@boolean can be used with it.
%    \begin{macrocode}
\let\sa@beamertrue\standalonebeamertrue
\let\sa@beamerfalse\standalonebeamerfalse
%    \end{macrocode}
%
% \begin{macro}{\sa@option}
% Wrapper macro to define options.
%    \begin{macrocode}
\def\sa@option{%
    \define@key{standalone.cls}%
}
%    \end{macrocode}
% \end{macro}
%
% \begin{key}{standalone.cls}{border}
% Sets the border around the content.
%    \begin{macrocode}
\sa@option{border}{%
    \sa@readborder#1 {} {} {} {} \@nnil
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{macro}{\sa@boolean}[2]{name of if-switch}{`true' or `false'}
% Sets if-switches.
%    \begin{macrocode}
\def\sa@boolean#1#2{%
    \begingroup
    \edef\@tempa{#2}%
    \def\@tempb{true}%
    \ifx\@tempa\@tempb
        \endgroup
        \csname sa@#1true\endcsname
    \else
        \endgroup
        \csname sa@#1false\endcsname
    \fi
}
%    \end{macrocode}
% \end{macro}
%
%
%
%
% \begin{key}{standalone.cls}{preview}
% Boolean to control if \pkg{preview} package should be used.
%    \begin{macrocode}
\sa@option{preview}[true]{%
    \sa@boolean{preview}{#1}%
    \ifsa@preview
        \sa@boxfalse
    \fi
}
\sa@previewtrue
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{crop}
% Boolean to control if own code should be used.
% That code boxes the content and resizes the page to match the box dimensions.
%    \begin{macrocode}
\sa@option{crop}[true]{%
    \sa@boolean{crop}{#1}%
    \ifsa@crop
        \sa@previewfalse
    \fi
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{ignorerest}
% Boolean to control if all other code outside of specified environments should be explicit ignored.
% That code boxes the outside content and then than discards it.
%    \begin{macrocode}
\sa@option{ignorerest}[true]{%
    \sa@boolean{ignorerest}{#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{varwidth}
% Boolean to control if \pkg{varwidth} package should be used.
% If so the content will be placed in a \env{varwidth} environment to avoid extending it to the full line width if a
% paragraph break is inserted.
%
% The option is by default set to true if the \pkg{varwidth} package is available.
%    \begin{macrocode}
\sa@option{varwidth}[true]{%
    \sa@boolean{varwidth}{#1}%
    \ifsa@varwidth
        \def\sa@varwidth{\varwidth{\linewidth}}%
        \def\sa@endvarwidth{\endvarwidth}%
    \else
        \let\sa@varwidth\@empty
        \let\sa@endvarwidth\@empty
    \fi
}
\IfFileExists{varwidth.sty}{%
    \setkeys{standalone.cls}{varwidth=true}%
}{}%
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{tikz}
%    \begin{macrocode}
\sa@option{tikz}[true]{%
    \sa@boolean{tikz}{#1}%
}
%    \end{macrocode}
% \end{key}
%
%
% \begin{key}{standalone.cls}{beamer}
% Boolean to control if the \cls{beamer} class is used.
%
% If true sets the class to \cls{beamer} and switches \opt{preview} off.
% If false the default class is restored if the current class was \cls{beamer}.
%    \begin{macrocode}
\sa@option{beamer}[true]{%
    \sa@boolean{beamer}{#1}%
    \ifstandalonebeamer
        \def\sa@class{beamer}%
        \sa@previewfalse
    \else
        \begingroup
        \def\@tempa{beamer}%
        \ifx\@tempa\sa@class
            \endgroup
            \def\sa@class{article}%
        \else
            \endgroup
        \fi
    \fi
}
%    \end{macrocode}
% \end{key}
%
% \begin{key}{standalone.cls}{class}
%    \begin{macrocode}
\sa@option{class}{%
    \def\sa@class{#1}%
}
\def\sa@class{article}
%    \end{macrocode}
% \end{key}
%
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
\InputIfFileExists{standalone.cfg}{}{}
%    \end{macrocode}
%
% Process options as normal keys. Only unknown keys are set as global options.
%    \begin{macrocode}
\begingroup
\def\@tempa{\endgroup\setkeys*{standalone.cls}}
\expandafter\@tempa\expandafter{\sa@classoptionslist}
\let\@classoptionslist\XKV@rm
%    \end{macrocode}
%
% Loads the class given by the |class| option with the rest of the options.
%    \begin{macrocode}
\expandafter\expandafter\expandafter\LoadClass
\expandafter\expandafter\expandafter[%
\expandafter\@classoptionslist
\expandafter]\expandafter{\sa@class}
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{General macros}
%
% \begin{macro}{\standaloneenv}[1]{comma separated list if environment names}
% Loops over all environment names and calls \Macro\@standaloneenv on them.
%    \begin{macrocode}
\newcommand*\standaloneenv[1]{%
    \begingroup
    \edef\@tempa{\endgroup\noexpand\@for\noexpand\@tempa:=\zap@space#1 \@empty}%
    \@tempa\do{\expandafter\@standaloneenv\expandafter{\@tempa}}%
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\standaloneconfig}
% User level configuration macro.
%    \begin{macrocode}
\newcommand*{\standaloneconfig}{\setkeys{standalone.cls}}
%    \end{macrocode}
% \end{macro}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Varwidth Option}
%
%    \begin{macrocode}
\ifsa@varwidth
    \RequirePackage{varwidth}
\fi
%    \end{macrocode}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{TikZ Option}
%
% Loads \pkg{tikz} and makes the \env{tikzpicture} environment and standalone environment.
%    \begin{macrocode}
\ifsa@tikz
    \RequirePackage{tikz}
    \AtEndOfPackage{\standaloneenv{tikzpicture}}
\fi
%    \end{macrocode}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Preview Option}
%
% The \env{standalone} environment is redefined to use the |preview| environment as
% long it was not redefined in the configuration file.
%    \begin{macrocode}
\ifsa@preview
%    \end{macrocode}
%
%    \begin{macrocode}
\RequirePackage[active,tightpage]{preview}
\ifsa@tikz\else
    \@ifundefined{endstandalone}{%
        \renewenvironment{standalone}
            {\preview\sa@varwidth}
            {\sa@endvarwidth\endpreview}
    }{}% TODO: Add info message?
\fi
%    \end{macrocode}
%
% Set Border
%    \begin{macrocode}
\def\PreviewBbAdjust{-\sa@border@left\space -\sa@border@bottom\space \sa@border@right\space \sa@border@top}%
%    \end{macrocode}
%
% \begin{macro}{\@standaloneenv}
% Preview version. Wrappes a \env{preview} environment around the original environment.
% Also adds the \env{varwidth} macros, which can be empty.
% These \env{varwidth} macros are the reason why \Macro\PreviewEnvironment is not used directly.
%    \begin{macrocode}
\def\@standaloneenv#1{%
    \expandafter\let\csname sa@orig@#1\expandafter\endcsname\csname #1\endcsname
    \expandafter\let\csname sa@orig@end#1\expandafter\endcsname\csname end#1\endcsname
    \expandafter\def\csname #1\endcsname{%
        \preview
        \sa@varwidth
        \csname sa@orig@#1\endcsname
    }%
    \expandafter\def\csname end#1\endcsname{%
        \csname sa@orig@end#1\endcsname
        \sa@endvarwidth
        \endpreview
    }%
}%
%    \end{macrocode}
% \end{macro}
%
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Crop Option}
%    \begin{macrocode}
\ifsa@crop
%    \end{macrocode}
%
% Box register to save the content.
% \begin{macro}{\sa@box}
%    \begin{macrocode}
\newbox\sa@box
%    \end{macrocode}
% \end{macro}
%
% Set all normal page margins etc. to zero.
%    \begin{macrocode}
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
%    \end{macrocode}
%
% \begin{macro}{\sa@boxit}
%    \begin{macrocode}
\def\sa@boxit{%
    \setbox\sa@box\hbox\bgroup\color@setgroup\sa@varwidth
}%
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\endsa@boxit}
%    \begin{macrocode}
\def\endsa@boxit{%
    \sa@endvarwidth\color@endgroup\egroup
}%
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\@standaloneenv}
% If the \opt{ignorerest} option is used all content outside of \Macro\standaloneenv\relax-ironments is
% boxed and discarded. This requires such environments to close the box first and reopen it afterwards.
%    \begin{macrocode}
\ifsa@ignorerest
    \renewenvironment{standalone}
        {\sa@boxit}
        {\endsa@boxit}
    \newcommand*\@standaloneenv[1]{%
        \expandafter\let\csname sa@orig@#1\expandafter\endcsname\csname #1\endcsname
        \expandafter\let\csname sa@orig@end#1\expandafter\endcsname\csname end#1\endcsname
        \expandafter\def\csname #1\endcsname{%
            \edef\@tempa{\endgroup
                \noexpand\endsa@boxit
                \begingroup
                \def\noexpand\@currenvir{\@currenvir}%
                \def\noexpand\@currenvline{\@currenvline}%
            }%
            \@tempa
            \sa@boxit
            \csname sa@orig@#1\endcsname
        }%
        \expandafter\def\csname end#1\endcsname{%
            \csname sa@orig@end#1\endcsname
            \endsa@boxit
            \sa@handlebox
            \aftergroup\sa@boxit
        }%
    }%
\else
    \newcommand*\@standaloneenv[1]{%
        \expandafter\let\csname sa@orig@#1\expandafter\endcsname\csname #1\endcsname
        \expandafter\let\csname sa@orig@end#1\expandafter\endcsname\csname end#1\endcsname
        \expandafter\def\csname #1\endcsname{%
            \sa@boxit
            \csname sa@orig@#1\endcsname
        }%
        \expandafter\def\csname end#1\endcsname{%
            \csname sa@orig@end#1\endcsname
            \endsa@boxit
            \sa@handlebox
        }%
    }%
\fi
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@handlebox}
% Adds the border as part of the box dimensions and places the result
% using the output format dependent \Macro\sa@placebox macro.
%    \begin{macrocode}
\def\sa@handlebox{%
    \sbox\sa@box{%
%    \end{macrocode}
% add left border
%    \begin{macrocode}
        \hskip\sa@border@left
%    \end{macrocode}
% add top border
%    \begin{macrocode}
        \@tempdima=\ht\sa@box
        \advance\@tempdima\sa@border@top\relax
        \ht\sa@box=\@tempdima
%    \end{macrocode}
% add bottom border
%    \begin{macrocode}
        \@tempdima=\dp\sa@box
        \advance\@tempdima\sa@border@bottom\relax
        \dp\sa@box=\@tempdima
%    \end{macrocode}
% Remove all depth, so that height=totalheight
%    \begin{macrocode}
        \raise\dp\sa@box
            \box\sa@box
%    \end{macrocode}
% add right border
%    \begin{macrocode}
        \hskip\sa@border@right
    }%
    \sa@placebox
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@placebox}
% Define output dependent macro to place the content box together
% with the required resizing of the page.
%    \begin{macrocode}
\RequirePackage{ifpdf}
\RequirePackage{ifxetex}
\ifpdf
    \def\sa@placebox{%
        \pdfpageheight=\ht\sa@box
        \pdfpagewidth=\wd\sa@box
        \noindent\usebox\sa@box\newpage
    }
\else
\ifxetex
    \def\sa@placebox{%
        \pdfpageheight=\ht\sa@box
        \pdfpagewidth=\wd\sa@box
        \noindent\usebox\sa@box\newpage
    }
\else
    \def\sa@placebox{%
        \paperheight=\ht\sa@box
        \paperwidth=\wd\sa@box
        \sa@papersize
        \begingroup
        \@tempdima0.99626\paperwidth
        \@tempdimb0.99626\paperheight
        \edef\@tempc{\strip@pt\@tempdima}%
        \edef\@tempd{\strip@pt\@tempdimb}%
        \advance\@tempdima by .998pt
        \advance\@tempdimb by .998pt
        \def\strip@float##1.##2\relax{##1}%
        \edef\@tempa{\expandafter\strip@float\the\@tempdima\relax}%
        \edef\@tempb{\expandafter\strip@float\the\@tempdimb\relax}%
        \special{ps::%
            \@percentchar\@percentchar PageBoundingBox: 0 0 \@tempa\space\@tempb^^J%
            \@percentchar\@percentchar HiResPageBoundingBox: 0 0 \@tempc\space\@tempd^^J%
            \@percentchar\@percentchar BeginPageSetup^^J%
            << /PageSize [\@tempc\space\@tempd]
            >> setpagedevice^^J%<<
            0 0 bop^^J%
            \@percentchar\@percentchar EndPageSetup}%
        \endgroup
        \noindent\sa@ps@content\newpage
    }
%    \end{macrocode}
% \end{macro}
%
% Other macros required for PostScript output.
% They will redefine themselves to act differently for the very first page than for the remaining ones.
% \begin{macro}{\sa@ps@content}
%
% Simply place the box of the first page. Further pages need to be vertically adjusted because the
% reference point is still for the size of the first page.
%    \begin{macrocode}
\def\sa@ps@content{%
    \usebox\sa@box
    \global\def\sa@sa@content{%
        \@tempdima-\ht\sa@box
        \advance\@tempdima+\sa@yoffset
        \@tempdima\sa@yoffset
        \advance\@tempdima-\f@size pt
        \dp\sa@box\z@
        \ht\sa@box\z@
        \lower\@tempdima\box\sa@box
    }%
}
%    \end{macrocode}
% \end{macro}
%
%
% \begin{macro}{\sa@papersize}
% Declare official papersize as the size of the first page.
% Store offset and disable this macro for all further pages.
%    \begin{macrocode}
\def\sa@papersize{%
    \global\let\sa@papersize\relax
    \special{papersize=\the\paperwidth,\the\paperheight}%
    \global\sa@yoffset=\paperheight
}
%    \end{macrocode}
% \end{macro}
%
% \begin{macro}{\sa@yoffset}
% Offset required to vertical adjust all further pages according to the first page.
%    \begin{macrocode}
\newlength\sa@yoffset
%    \end{macrocode}
% \end{macro}
%
% End of |\ifpdf .. \else\ifxetex .. \else| statement.
%    \begin{macrocode}
\fi\fi
%    \end{macrocode}
%
% End of \opt{crop} option code.
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Beamer code}
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Document Environment in Sub-Files}
% This is done at the very end so that all used packages are already loaded.
% Just in case these try also to redefine the \env{document} environment.
%
% \begin{environment}{document}
% Adds own `after begin document' and `before end document` hooks.
%    \begin{macrocode}
\begingroup
\toks@\expandafter{%
    \document
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
\def\sa@cls@afterbegindocument{\standalone\ignorespaces}
\def\sa@cls@beforeenddocument{\ifhmode\unskip\fi\endstandalone}
%    \end{macrocode}
% \end{macro}
% \end{macro}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
