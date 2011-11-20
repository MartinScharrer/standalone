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
% \subsubsection{Options}
%
%    \begin{macrocode}
\let\sa@classoptionslist\@classoptionslist
\RequirePackage{xkeyval}
\newif\ifsa@preview
\newif\ifsa@box
\newif\ifsa@varwidth
\newif\ifsa@ignore
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
% \begin{key}{standalone.cls}{box}
% Boolean to control if own code should be used.
% That code boxes the content and resizes the page to match the box dimensions.
%    \begin{macrocode}
\sa@option{box}[true]{%
    \sa@boolean{box}{#1}%
    \ifsa@box
        \sa@previewfalse
    \fi
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
% paragraph break is inserted.
%    \begin{macrocode}
\sa@option{beamer}[true]{%
    \sa@boolean{beamer}{#1}%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Varwidth Option}
%
%    \begin{macrocode}
\ifsa@varwidth
    \RequirePackage{varwidth}
\fi
%    \end{macrocode}
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% \subsubsection{Preview Option}
%
% The \env{standalone} environment is redefined to use the |preview| environment as
% long it was not redefined in the configuration file.
%    \begin{macrocode}
\ifsa@preview
    \RequirePackage[active,tightpage]{preview}
    \ifsa@tikz
        \RequirePackage{tikz}
        \PreviewEnvironment{tikzpicture}
    \else
        \@ifundefined{endstandalone}{%
            \ifsa@varwidth
                \renewenvironment{standalone}
                {\preview\sa@varwidth}
                {\sa@endvarwidth\endpreview}
            \else
                \renewenvironment{standalone}
                {\preview   }
                {\endpreview}
            \fi
        }{}% TODO: Add info message?
    \fi
%    \end{macrocode}
% Set Border
%    \begin{macrocode}
    \xdef\PreviewBbAdjust{-\sa@border@left\space -\sa@border@bottom\space \sa@border@right\space \sa@border@top}%
%    \end{macrocode}
% Define \Macro\@standaloneenv macro.
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
%    \begin{macrocode}
\fi
%    \end{macrocode}
%
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
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
