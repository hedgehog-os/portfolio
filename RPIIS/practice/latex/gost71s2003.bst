%%
%% This is file `gost71s2003.bst',
%% modified from `gost780s.bst' (author: Maksym Polyakov)
%% and `gost71s2003.bst'(author: Vadzim Piatrou).
%%
%%
%% Copyright 2011-2012 Denis Kazakevich.
%% Version 0.6
%%
%% This file may be distributed and/or modified under the
%% conditions of the LaTeX Project Public License, either version 1.2
%% of this license or (at your option) any later version.
%% The latest version of this license is in
%%   http://www.latex-project.org/lppl.txt
%% and version 1.2 or later is part of all distributions of LaTeX
%% version 1999/12/01 or later.
%%
%% Please, send bug reports via e-mail:
%%   thesisby@tut.by
%%
%%
%%
%% This bibliography style attempts
%% to format bibliography according to
%% GOST 7.1-2003
%%
%% For the Ukrainian|Russian bibliographic entries
%% you need to create field
%% language = {ukrainian|russian}.
%% Default language is English.
%% Field numpages for books must contain number of pages.
%% Optional field url will format url (using hyperref, if loaded).
%%
%% Requires 8-bit bibtex with switch -B and csf file supporting cyrillic.
%% bibtex8 -B -c <encoding>.csf <your_document>
%%

ENTRY
  { address
    annote
    author
    booktitle
    bookauthor
    chapter
    edition
    editor
    compiler
    howpublished
    institution
    journal
    key
    month
    note
    number
    organization
    pages
    numpages
    publisher
    school
    series
    title
    type
    volume
    year
    language
    booklanguage
    url
  }
  {}
  { label }

INTEGERS { output.state before.all mid.sentence after.sentence after.block
after.dblslash after.slash after.column after.semicolumn}

FUNCTION {init.state.consts}
{ #0 'before.all :=
  #1 'mid.sentence :=
  #2 'after.sentence :=
  #3 'after.block :=
  #4 'after.dblslash :=
  #5 'after.slash :=
  #6 'after.column :=
  #7 'after.semicolumn :=
}

STRINGS { s t }

STRINGS { curlanguage }

FUNCTION {change.language}
{ booklanguage empty$
    {""}
    {booklanguage  'curlanguage :=
    "\selectlanguageifdefined{"
    curlanguage *
    "}" *
     }
  if$
}

FUNCTION {output.nonnull}
{ 's :=
  output.state mid.sentence =
    { ", " * write$ }
    { output.state after.block =
        { add.period$ write$
          " " quote$ "--- " * *  write$
          newline$
          "\newblock " write$
        }
        { output.state before.all =
            'write$
            { output.state after.dblslash =
                { "~//" * change.language * " " * write$ }
                { output.state after.slash =
                    { "~/ " * write$ }
                    { output.state after.column =
                       { ": " * write$ }
                       { output.state after.semicolumn =
                           { "; " * write$ }
                   { add.period$ " " * write$ }
                     if$
    }
                    if$
                  }
                  if$
                }
              if$
            }
          if$
        }
      if$
      mid.sentence 'output.state :=
    }
  if$
  s
}

FUNCTION {output}
{ duplicate$ empty$
    'pop$
    'output.nonnull
  if$
}

FUNCTION {output.check}
{ 't :=
  duplicate$ empty$
    { pop$ "empty " t * " in " * cite$ * warning$ }
    'output.nonnull
  if$
}

FUNCTION {fin.entry}
{ add.period$
  write$
  newline$
}

FUNCTION {new.block}
{ output.state before.all =
    'skip$
    { after.block 'output.state := }
  if$
}

FUNCTION {new.dblslash}
{ output.state before.all =
    'skip$
    { after.dblslash 'output.state := }
  if$
}

FUNCTION {new.slash}
{ output.state before.all =
    'skip$
    { after.slash 'output.state := }
  if$
}

FUNCTION {new.column}
{ output.state before.all =
    'skip$
    { after.column 'output.state := }
  if$
}

FUNCTION {new.semicolumn}
{ output.state before.all =
    'skip$
    { after.semicolumn 'output.state := }
  if$
}

FUNCTION {new.sentence}
{ output.state after.block =
    'skip$
    { output.state before.all =
        'skip$
        { after.sentence 'output.state := }
      if$
    }
  if$
}

FUNCTION {add.blank}
{ " " * before.all 'output.state :=
}

FUNCTION {not}
{   { #0 }
    { #1 }
  if$
}

FUNCTION {and}
{   'skip$
    { pop$ #0 }
  if$
}

FUNCTION {or}
{   { pop$ #1 }
    'skip$
  if$
}

FUNCTION {non.stop}
{ duplicate$
   "}" * add.period$
   #-1 #1 substring$ "." =
}

FUNCTION {new.block.checka}
{ empty$
    'skip$
    'new.block
  if$
}

FUNCTION {new.block.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.block
  if$
}

FUNCTION {new.sentence.checka}
{ empty$
    'skip$
    'new.sentence
  if$
}

FUNCTION {new.sentence.checkb}
{ empty$
  swap$ empty$
  and
    'skip$
    'new.sentence
  if$
}

FUNCTION {field.or.null}
{ duplicate$ empty$
    { pop$ "" }
    'skip$
  if$
}

FUNCTION {emphasize}
{ duplicate$ empty$
    { pop$ "" }
    { "\BibEmph{" swap$ * "}" * }
  if$
}

FUNCTION {space.word}
{ " " swap$ * " " * }

FUNCTION {bbl.edby}    %  { "\bbledby{}" }
{  curlanguage "english" =
    {"ed.: "}
    { curlanguage "ukrainian" =
        {"{\cyr\CYRP\cyrii\cyrd\ \cyrr\cyre\cyrd.\ }"}
        { curlanguage "russian" =
           {"  "}
           {"language is not defined: " language  "edited by" * * warning$ "ed.: "}
         if$}
      if$}
  if$
}

FUNCTION {bbl.cmplr}
{  curlanguage "english" =
    {"Compiler "}
    { curlanguage "ukrainian" =
        {"{\cyr\CYRU\cyrk\cyrl.\ }"}
        { curlanguage "russian" =
           {"авт.-сост.: "}
           {"language is not defined: " language  "compiler" * * warning$ "compiler"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.edition} %  { "\bbledition{}" }
{  curlanguage "english" =
    {"ed."}
    { curlanguage "ukrainian" =
        {"{\cyr\cyrv\cyri\cyrd.}"}
        { curlanguage "russian" =
           {"изд."}
           {"language is not defined: " language  "edition" * * warning$ "edition"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.vvolume} %  { "\bblVolume{}" }
{  curlanguage "english" =
    {"Volume"}
    { curlanguage "ukrainian" = curlanguage "russian" = or
        {"\CYRT\cyro\cyrm"}
        {"language is not defined: " language  "Volume" * * warning$ "Volume"}
      if$}
  if$
}

FUNCTION {bbl.vvol}    %  { "\bblVol{}" }
{  curlanguage "english" =
    {"Vol."}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"\CYRT."}
           {"language is not defined: " language  "Vol." * * warning$ "Vol."}
      if$}
  if$
}

FUNCTION {bbl.iissue}  %  { "\bblIssue{}" }
{  curlanguage "english" =
    {"Issue"}
    { curlanguage "ukrainian" =
        {"\CYRV\cyri\cyrp\cyru\cyrs\cyrk"}
        { curlanguage "russian" =
           {"\CYRV\cyrery\cyrp\cyru\cyrs\cyrk"}
           {"language is not defined: " language * warning$ "Issue"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.iiss}  %  { "\bblIss{}" }
{  curlanguage "english" =
    {"Iss."}
    { curlanguage "ukrainian" =
        {"\CYRV\cyri\cyrp."}
        { curlanguage "russian" =
           {"\CYRV\cyrery\cyrp."}
           {"language is not defined: " language * warning$ "Issue"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.of}      %  { "\bblof{}" }
{  curlanguage "english" =
    {"of"}
    { curlanguage "ukrainian" =
        {"{\cyr\cyrii\cyrz}"}
        { curlanguage "russian" =
           {"{\cyr\cyri\cyrz}"}
           {"language is not defined: " language "of" *  * warning$ "of"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.etal}      %  { "\bblof{}" }
{  curlanguage "english" =
    {"[et~al.]"}
    { curlanguage "ukrainian" =
        {"[{\cyr\cyrt\cyra~\cyrii\cyrn.}]"}
        { curlanguage "russian" =
           {"[{\cyr\cyri~\cyrd\cyrr.}]"}
           {"language is not defined: " language  "[et al]" * * warning$ "[et al]"}
         if$}
      if$}
  if$
}

FUNCTION {bbl.nnumber} %  { "\bblNumber{}" }
{  curlanguage "english" =
    {"Number"}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"\CYRN\cyro\cyrm\cyre\cyrr"}
           {"language is not defined: " language  "Number" * * warning$ "Number"}
      if$}
  if$
}

FUNCTION {bbl.number}  %  { "\bblnumber{}" }
{  curlanguage "english" =
    {"number"}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\cyrn\cyro\cyrm\cyre\cyrr}"}
           {"language is not defined: " language  "number" * * warning$ "number"}
      if$}
  if$
}

FUNCTION {bbl.nr}     %   { "\bblno{}" }
{  curlanguage "english" =
    {"{\cyr\textnumero}"}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\textnumero}"}
           {"language is not defined: " language  "no." * * warning$ "no."}
      if$}
  if$
}

FUNCTION {bbl.nnr}     %   { "\bblno{}" }
{  curlanguage "english" =
    {"{\cyr\textnumero}"}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\textnumero}"}
           {"language is not defined: " language  "No." * * warning$ "No."}
      if$}
  if$
}

FUNCTION {bbl.in}    %    { "\bblin{}" }
{  curlanguage "english" =
    {"in"}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\cyrv}"}
           {"language is not defined: " language  "in" * * warning$ "in"}
      if$}
  if$
}

FUNCTION {bbl.iin}  %     { "\bblIn{}" }
{  curlanguage "english" =
    {"In"}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"\CYRV"}
           {"language is not defined: " language  "In" * * warning$ "In"}
      if$}
  if$
}

FUNCTION {bbl.pages}    % { "\bblpp." }
{  curlanguage "english" =
    {"p."}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\cyrs.}"}
           {"language is not defined: " language  "pp." * * warning$ "p."}
      if$}
  if$
}

FUNCTION {bbl.page}   %   { "\bblp."
{  curlanguage "english" =
    {"p."}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\cyrs.}"}
           {"language is not defined: " language  "p." * * warning$ "p."}
      if$}
  if$
}

FUNCTION {bbl.ppages}%    { "\bblPp." }
{  curlanguage "english" =
    {"P."}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\CYRS.}"}
           {"language is not defined: " language  "P." * * warning$ "P."}
      if$}
  if$
}

FUNCTION {bbl.ppage}  %   { "\bblP." }
{  curlanguage "english" =
    {"P."}
    { curlanguage "ukrainian" = curlanguage "russian" = or
           {"{\cyr\CYRS.}"}
           {"language is not defined: " language  "P." * * warning$ "P."}
      if$}
  if$
}


FUNCTION {bbl.techrep}   { "Tech. Rep." }
FUNCTION {bbl.mthesis}   { "Master's thesis" }
FUNCTION {bbl.phdthesis} { "Ph.D. thesis" }

INTEGERS { nameptr namesleft numnames }


FUNCTION {format.names}
{
  #1 "{vv~}{ll}{~jj},{~ff}" format.name$
}


FUNCTION {format.names.rev}
{ 's :=
  #1 'nameptr :=
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { s nameptr
      "{ff~}{vv~}{ll}{, jj}"
      format.name$ 't :=
      nameptr #1 >
        {
          nameptr #2 =
          numnames #3 > and
            { "others" 't :=
              #1 'namesleft := }
            'skip$
          if$
          namesleft #1 >
            { ", " * t * }
            {
              t "others" =
                { " " * bbl.etal * }
                { ", " * t * }
              if$
            }
          if$
        }
        't
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {format.authors}
{ author empty$
    { "" }
    { author format.names}
  if$
}

FUNCTION {format.bookauthors}
{ bookauthor empty$
    { "" }
    { bookauthor format.names}
  if$
}

FUNCTION {format.authors.after}
{ author empty$
    { "" }
    { author format.names.rev}
  if$
}

FUNCTION {format.bookauthors.after}
{ bookauthor empty$
    { "" }
    { bookauthor format.names.rev}
  if$
}

FUNCTION {format.editors.after}
{ editor empty$
    { "" }
    { bbl.edby editor format.names.rev *
    }
  if$
}

FUNCTION {format.compiler.after}
{ compiler empty$
    { "" }
    { bbl.cmplr compiler format.names.rev *
    }
  if$
}

FUNCTION {format.title}
{ title empty$
    { "" }
    { title "t" change.case$
    }
  if$
}

FUNCTION {output.address.publisher.date}
{
      address empty$
        'skip$
        { address output
          publisher empty$
            'skip$
            { new.column
            }
          if$
        }
        if$
        publisher output
        year "year" output.check
}

FUNCTION {output.bibitem}
{ newline$
  "\bibitem{" write$
  cite$ write$
  "}" write$
  newline$
  language empty$
    {"english" 'curlanguage :=}
    {language  'curlanguage :=}
  if$
  "\selectlanguageifdefined{" write$
  curlanguage write$
  "}" write$ newline$
  ""
  before.all 'output.state :=
}

FUNCTION {n.dashify}
{ 't :=
  ""
    { t empty$ not }
    { t #1 #1 substring$ "-" =
        { t #1 #2 substring$ "--" = not
            { "--" *
              t #2 global.max$ substring$ 't :=
            }
            {   { t #1 #1 substring$ "-" = }
                { "-" *
                  t #2 global.max$ substring$ 't :=
                }
              while$
            }
          if$
        }
        { t #1 #1 substring$ *
          t #2 global.max$ substring$ 't :=
        }
      if$
    }
  while$
}

FUNCTION {word.in}
{ bbl.iin
  " " * }

FUNCTION {format.date}
{ year empty$
{ "" }
'year
if$
}

FUNCTION {format.btitle}
{ title
}

FUNCTION {tie.or.space.connect}
{ duplicate$ text.length$ #3 <
    { "~" }
    { " " }
  if$
  swap$ * *
}

FUNCTION {tie.connect}
 {"~"
  swap$ * *
 }

FUNCTION {either.or.check}
{ empty$
    'pop$
    { "can't use both " swap$ * " fields in " * cite$ * warning$ }
  if$
}

FUNCTION {format.bvolume}
{ volume empty$
    { "" }
    { bbl.vvol volume tie.connect
      series empty$
        'skip$
        { bbl.of space.word * series emphasize * }
      if$
      "volume and number" number either.or.check
    }
  if$
}

FUNCTION {format.number.series}
{ volume empty$
    { number empty$
        { series field.or.null }
        { series empty$
            { "there's a number but no series in " cite$ * warning$
              bbl.nnr }
            {
              %new.dblslash
              new.sentence
              series
              bbl.nr
              tie.or.space.connect}
          if$
          number tie.or.space.connect
        }
      if$
    }
    { "" }
  if$
}

FUNCTION {is.num}
{ chr.to.int$
  duplicate$ "0" chr.to.int$ < not
  swap$ "9" chr.to.int$ > not and
}

FUNCTION {extract.num}
{ duplicate$ 't :=
  "" 's :=
  { t empty$ not }
  { t #1 #1 substring$
    t #2 global.max$ substring$ 't :=
    duplicate$ is.num
      { s swap$ * 's := }
      { pop$ "" 't := }
    if$
  }
  while$
  s empty$
    'skip$
    { pop$ s }
  if$
}


FUNCTION {convert.edition}
{ edition
}

FUNCTION {format.edition}
{ edition empty$
    { "" }
    { output.state mid.sentence =
        { convert.edition "l" change.case$ " " * bbl.edition * }
        { convert.edition "t" change.case$ " " * bbl.edition * }
      if$
    }
  if$
}

INTEGERS { multiresult }

FUNCTION {multi.page.check}
{ 't :=
  #0 'multiresult :=
    { multiresult not
      t empty$ not
      and
    }
    { t #1 #1 substring$
      duplicate$ "-" =
      swap$ duplicate$ "," =
      swap$ "+" =
      or or
        { #1 'multiresult := }
        { t #2 global.max$ substring$ 't := }
      if$
    }
  while$
  multiresult
}

FUNCTION {format.pages}
{ pages empty$
    { "" }
    { pages multi.page.check
        { bbl.ppages pages n.dashify tie.connect }
        { bbl.ppage pages tie.connect }
      if$
    }
  if$
}

FUNCTION {format.pages.page}
{ pages empty$
    { numpages empty$
      { "" }
      { numpages bbl.pages tie.connect }
    if$}
    { format.pages}
  if$
}

FUNCTION {format.vol.num.pages}
{ volume field.or.null
  number empty$
    'skip$
    {
      ", no." number tie.or.space.connect *
      volume empty$
        { "there's a number but no volume in " cite$ * warning$ }
        'skip$
      if$
    }
  if$
  pages empty$
    'skip$
    { duplicate$ empty$
        { pop$ format.pages }
        { ": " * pages n.dashify * }
      if$
    }
  if$
}

FUNCTION {format.volume}
{ volume empty$
    { "" }
    { bbl.vvol volume tie.or.space.connect }
  if$
}

FUNCTION {format.number}
{ number empty$
    { "" }
    { bbl.nr number tie.or.space.connect }
  if$
}


FUNCTION {empty.misc.check}
{ author empty$ title empty$ howpublished empty$
  month empty$ year empty$ note empty$
  and and and and and
  key empty$ not and
    { "all relevant fields are empty in " cite$ * warning$ }
    'skip$
  if$
}

FUNCTION {format.thesis.type}
{ type empty$
    'skip$
    { pop$
      type "t" change.case$
    }
  if$
}

FUNCTION {format.tr.number}
{ type empty$
    { bbl.techrep }
    'type
  if$
  number empty$
    { "t" change.case$ }
    { number tie.or.space.connect }
  if$
}

FUNCTION {author.before}
{
  author empty$
    'skip$
    {author num.names$ #4 <
      {format.authors output
       new.sentence}
      'skip$
    if$}
  if$
}

FUNCTION {bookauthor.before}
{
  bookauthor empty$
    'skip$
    {bookauthor num.names$ #4 <
      {format.bookauthors output
       new.sentence}
      'skip$
    if$}
  if$
}


FUNCTION {author.after}
{
  author empty$
    'skip$
    {format.authors.after output
       new.semicolumn }
  if$
}
FUNCTION {bookauthor.after}
{
  bookauthor empty$
    'skip$
    {format.bookauthors.after output
       new.semicolumn }
  if$
}

FUNCTION {editor.organization.after}
{
  compiler empty$
    {}
    { format.compiler.after  output
    new.semicolumn
    }
  if$
  editor empty$
    {}
    { format.editors.after  output
    new.semicolumn
    }
  if$
  organization empty$
    {}
    {organization output
    new.semicolumn
    }
  if$
}

FUNCTION {format.url}
{ url empty$
    { "" }
    { after.sentence 'output.state :=
      "\BibUrl{ " url * "}" *
    }
  if$
}

FUNCTION {format.annote}
{ annote empty$
    { "" }
{ after.sentence 'output.state :=
  "\BibAnnote{" annote add.period$ * "}" *
}
  if$
}

FUNCTION {article}
{ output.bibitem
  author.before
  format.title "title" output.check
  new.slash
  author.after
  new.dblslash
  journal "journal" output.check
  new.block
  format.date output
  new.block
  format.volume output
  format.number output
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.annote output
  fin.entry
}

FUNCTION {book}
{ output.bibitem
  author.before
  format.btitle "title" output.check
  new.slash
  author.after
  editor.organization.after
  new.sentence
  format.number.series output
  new.block
  format.edition output
  new.block
  output.address.publisher.date
  new.block
  format.bvolume output
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {booklet}
{ output.bibitem
  author.before
  format.title "title" output.check
  new.slash
  author.after
  editor.organization.after
  new.block
  howpublished output
  address output
  format.date output
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {inbook}
{ output.bibitem
  author.before
  format.btitle "title" output.check
  new.slash
  author.after
  new.dblslash
  bookauthor.before
  booktitle "booktitle" output.check
  new.slash
  bookauthor.after
  editor.organization.after
  new.block
  format.edition output
  new.block
  format.number.series output
  new.sentence
  output.address.publisher.date
  new.block
  format.bvolume output
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {incollection}
{ output.bibitem
  author.before
  new.sentence
  format.title "title" output.check
  new.slash
  author.after
  new.dblslash
  booktitle "booktitle" output.check
  new.slash
  editor.organization.after
  new.block
  output.address.publisher.date
  new.block
  format.bvolume output
  format.number.series output
  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {inproceedings}
{ output.bibitem
  author.before
  new.sentence
  format.title "title" output.check
  new.slash
  author.after
  new.dblslash
  booktitle "booktitle" output.check
  new.slash
  editor.organization.after
  new.block
  address empty$
    { publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      new.column
      publisher output
      format.date "year" output.check
    }
  if$
  new.block
  format.bvolume output
  format.number.series output

  new.block
  format.pages.page output
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {conference} { inproceedings }

FUNCTION {manual}
{ output.bibitem
  author empty$
    { organization empty$
        'skip$
        { organization output.nonnull
          address output
        }
      if$
    }
    { format.authors output.nonnull }
  if$
  new.block
  format.btitle "title" output.check
  author empty$
    { organization empty$
    {
          address new.block.checka
          address output
        }
        'skip$
      if$
    }
    {
      organization address new.block.checkb
      organization output
      address output
    }
  if$
  format.edition output
  format.date output
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {mastersthesis}
{ output.bibitem
  format.authors "author" output.check
  new.block
  format.btitle "title" output.check
  new.block
  bbl.mthesis format.thesis.type output.nonnull
  school "school" output.check
  address output
  format.date "year" output.check
  new.block
  note output
  new.block
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {misc}
{ output.bibitem
  format.authors output
  title howpublished new.sentence.checkb
  format.title output
  howpublished new.block.checka
  howpublished output
  new.block
  format.date output
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {phdthesis}
{ output.bibitem
  format.authors "author" output.check
  new.sentence
  format.btitle "title" output.check
  new.column
  bbl.phdthesis format.thesis.type output.nonnull
  new.slash
  author.after
  school "school" output.check
  new.block
  output.address.publisher.date
  new.block
  format.pages.page output
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {proceedings}
{ output.bibitem
  format.btitle "title" output.check
  new.slash
  editor.organization.after
  new.block
  format.bvolume output
  format.number.series output
  address empty$
    { publisher output
      format.date "year" output.check
    }
    { address output.nonnull
      format.date "year" output.check
      new.sentence
      publisher output
    }
  if$
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {techreport}
{ output.bibitem
  author.before
  new.sentence
  format.title "title" output.check
  new.column
  format.tr.number output.nonnull
  new.slash
  author.after
  editor.organization.after
  new.block
  address output
  new.column
  institution "institution" output.check
  format.date "year" output.check
  new.block
  note output
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {unpublished}
{ output.bibitem
  author.before
  format.btitle "title" output.check
  new.slash
  author.after
  editor.organization.after
  new.block
  note "note" output.check
  new.sentence
  format.url output
  format.annote output
  fin.entry
}

FUNCTION {default.type} { misc }

MACRO {jan} {"\bbljan{}"}

MACRO {feb} {"\bblfeb{}"}

MACRO {mar} {"\bblmar{}"}

MACRO {apr} {"\bblapr{}"}

MACRO {may} {"\bblmay{}"}

MACRO {jun} {"\bbljun{}"}

MACRO {jul} {"\bbljul{}"}

MACRO {aug} {"\bblaug{}"}

MACRO {sep} {"\bblsep{}"}

MACRO {oct} {"\bbloct{}"}

MACRO {nov} {"\bblnov{}"}

MACRO {dec} {"\bbldec{}"}

MACRO {acmcs} {"ACM Computing Surveys"}

MACRO {acta} {"Acta Informatica"}

MACRO {cacm} {"Communications of the ACM"}

MACRO {ibmjrd} {"IBM Journal of Research and Development"}

MACRO {ibmsj} {"IBM Systems Journal"}

MACRO {ieeese} {"IEEE Transactions on Software Engineering"}

MACRO {ieeetc} {"IEEE Transactions on Computers"}

MACRO {ieeetcad}
 {"IEEE Transactions on Computer-Aided Design of Integrated Circuits"}

MACRO {ipl} {"Information Processing Letters"}

MACRO {jacm} {"Journal of the ACM"}

MACRO {jcss} {"Journal of Computer and System Sciences"}

MACRO {scp} {"Science of Computer Programming"}

MACRO {sicomp} {"SIAM Journal on Computing"}

MACRO {tocs} {"ACM Transactions on Computer Systems"}

MACRO {tods} {"ACM Transactions on Database Systems"}

MACRO {tog} {"ACM Transactions on Graphics"}

MACRO {toms} {"ACM Transactions on Mathematical Software"}

MACRO {toois} {"ACM Transactions on Office Information Systems"}

MACRO {toplas} {"ACM Transactions on Programming Languages and Systems"}

MACRO {tcs} {"Theoretical Computer Science"}

READ


FUNCTION {sortify}
{ purify$
  "l" change.case$
}

INTEGERS { len }

FUNCTION {chop.word}
{ 's :=
  'len :=
  s #1 len substring$ =
    { s len #1 + global.max$ substring$ }
    's
  if$
}

FUNCTION {sort.format.names}
{ 's :=
  #1 'nameptr :=
  ""
  s num.names$ 'numnames :=
  numnames 'namesleft :=
    { namesleft #0 > }
    { nameptr #1 >
        { "   " * }
        'skip$
      if$
      s nameptr
      "{vv{ } }{ll{ }}{  f{ }}{  jj{ }}"
      format.name$ 't :=
      nameptr numnames = t "others" = and
        { "et al" * }
        { t sortify * }
      if$
      nameptr #1 + 'nameptr :=
      namesleft #1 - 'namesleft :=
    }
  while$
}

FUNCTION {sort.format.title}
{ 't :=
  "A " #2
    "An " #3
      "The " #4 t chop.word
    chop.word
  chop.word
  sortify
  #1 global.max$ substring$
}

FUNCTION {author.sort}
{ author empty$
    { key empty$
        { "to sort, need author or key in " cite$ * warning$
          ""
        }
        { key sortify }
      if$
    }
    {
      author num.names$ #4 <
        {author sort.format.names }
        {title sort.format.title}
      if$
    }
  if$
}

FUNCTION {author.title.sort}
{ author empty$
    { title empty$
        { key empty$
            { "to sort, need author, title, or key in " cite$ * warning$
              ""
            }
            { key sortify }
          if$
        }
        { title sort.format.title }
      if$
    }
    {
      author num.names$ #4 <
        {author sort.format.names }
        {title sort.format.title}
      if$
     }
  if$
}

FUNCTION {presort}
{
  language "russian" =
  	{"!"}
	{""}
  if$
  author.title.sort
  *
  "   "
  *
  year field.or.null sortify
  *
  "   "
  *
  title field.or.null
  sort.format.title
  *
  #1 entry.max$ substring$
  'sort.key$ :=
}


SORT

STRINGS { longest.label }

INTEGERS { number.label longest.label.width }

FUNCTION {initialize.longest.label}
{ "" 'longest.label :=
  #1 'number.label :=
  #0 'longest.label.width :=
}

FUNCTION {longest.label.pass}
{ number.label int.to.str$ 'label :=
  number.label #1 + 'number.label :=
  label width$ longest.label.width >
    { label 'longest.label :=
      label width$ 'longest.label.width :=
    }
    'skip$
  if$
}

EXECUTE {initialize.longest.label}

ITERATE {longest.label.pass}

FUNCTION {begin.bib}
{ "\begin{thebibliography}{"  longest.label  * "}" * write$ newline$
  "\def\selectlanguageifdefined#1{"                  write$ newline$
  "\expandafter\ifx\csname date#1\endcsname\relax"   write$ newline$
  "\else\language\csname l@#1\endcsname\fi}"                  write$ newline$
  "\ifx\undefined\url\def\url#1{{\small #1}}\else\fi"                  write$ newline$
  "\ifx\undefined\BibUrl\def\BibUrl#1{\url{#1}}\else\fi"   write$ newline$
  "\ifx\undefined\BibAnnote\long\def\BibAnnote#1{}\else\fi"    write$ newline$
  "\ifx\undefined\BibEmph\def\BibEmph#1{\emph{#1}}\else\fi"    write$ newline$
  preamble$ empty$
    'skip$
    { preamble$ write$ newline$ }
  if$
}

EXECUTE {begin.bib}

EXECUTE {init.state.consts}

ITERATE {call.type$}

FUNCTION {end.bib}
{ newline$
  "\end{thebibliography}" write$ newline$
}

EXECUTE {end.bib}

%%
%% End of file `gost71s2003.bst'.