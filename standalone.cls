\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{standalone}[2010/03/18 v0.1 Allow TeX snippets to be included or be compile standalone]

\def\sa@classoptionslist{}
\RequirePackage{kvoptions}
\SetupKeyvalOptions{prefix=sa@}
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

\RequirePackage[tightpage]{preview}

\RequirePackage{standalone}[2010/03/18]
\standalonetrue

\def\document{%
  \sa@orig@document
  \let\documentclass\sa@documentclass
  \preview
}

\def\enddocument{%
  \endpreview
  \sa@orig@enddocument
}
% vim: ft=tex
