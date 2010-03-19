\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{standalone}[2010/03/18 v0.1 Allow TeX snippets to be included or be compile standalone]

\def\sa@classoptionslist{}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{prefix=sa@}
\DeclareBoolOption[true]{preview}

\def\sa@cls@document{\ifsa@preview\preview\fi}
\def\sa@cls@enddocument{\ifsa@preview\endpreview\fi}

\DeclareVoidOption{beamer}{%
  \def\sa@class{beamer}%
  \sa@previewfalse
  \newenvironment{standalone}[1][]{%
  \begin{frame}[fragile,environment=standalone]}{\end{frame}}%
}
\DeclareStringOption[article]{class}
\DeclareStringOption[]{classoptions}
\DeclareStringOption[]{frameoptions}
\DeclareDefaultOption{%
  \xdef\sa@classoptionslist{\sa@classoptionslist,\CurrentOption}%
}
\input{standalone.cfg}
\ProcessKeyvalOptions*\relax

\let\@classoptionslist\sa@classoptionslist
\xdef\@tempa{[\sa@classoptions]{\sa@class}}
\expandafter\LoadClass\@tempa

\ifsa@preview
  \RequirePackage{preview}
\fi

\RequirePackage{standalone}[2010/03/18]
\standalonetrue

\def\document{%
  \sa@orig@document
  \let\documentclass\sa@documentclass
  \sa@cls@document
}

\def\enddocument{%
  \sa@cls@enddocument
  \sa@orig@enddocument
}
% vim: ft=tex
