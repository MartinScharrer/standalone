\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{standalone}[2010/03/18 v0.1 Allow TeX snippets to be included or be compile standalone]

\newenvironment{standalone}{\preview}{\endpreview}

\def\sa@classoptionslist{}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{prefix=sa@}
\DeclareBoolOption[true]{preview}
\DeclareVoidOption{beamer}{%
  \def\sa@class{beamer}%
  \sa@previewfalse
  \renewenvironment{standalone}{\begin{frame}}{\end{frame}}%
}
\DeclareStringOption[article]{class}
\DeclareStringOption[]{classoptions}
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
  \begin{standalone}%
}

\def\enddocument{%
  \end{standalone}%
  \sa@orig@enddocument
}
% vim: ft=tex
