\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{standalone}[2010/03/18 v0.1 Allow TeX snippets to be included or be compile standalone]

\def\sa@class{article}
\def\sa@classoptions{}
\input{standalone.cfg}
\RequirePackage[tightpage]{preview}
\expandafter\expandafter\expandafter\LoadClass
\expandafter\expandafter\expandafter[%
\expandafter\sa@classoptions\expandafter]\expandafter{\sa@class}

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
