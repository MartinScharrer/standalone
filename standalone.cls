\ProvidesClass{standalone}[2010/01/21 Allow TeX snippets to be included or be compile standalone]
\LoadClass{article}
\pagestyle{empty}

\RequirePackage[active,tightpage]{preview}

\newif\ifstandalone
\standalonetrue

\let\sa@orig@document\document
  \let\document\sa@document
\let\sa@orig@enddocument\enddocument

\def\document{%
  \sa@orig@document\preview
}

\def\enddocument{%
  \endpreview\sa@orig@enddocument
}
% vim: ft=tex
