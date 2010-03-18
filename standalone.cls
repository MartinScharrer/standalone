\ProvidesClass{standalone}[2010/03/18 Allow TeX snippets to be included or be compile standalone]

\newif\ifstandalone
\standalonetrue

\def\sa@class{article}
\input{standalone.cfg}
\RequirePackage[tightpage]{preview}
\expandafter\LoadClass\expandafter{\sa@class}

\let\sa@orig@document\document
\let\sa@orig@enddocument\enddocument

\def\document{%
  \sa@orig@document\preview
}

\def\enddocument{%
  \endpreview\sa@orig@enddocument
}
% vim: ft=tex
