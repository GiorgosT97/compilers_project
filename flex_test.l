%{
#include "bison_test.tab.h"

%}
%option noyywrap

letter [a-zA-Z]
word   {letter}{letter}+
digit  [0-9]
number {digit}{digit}+
alphar ({letter}|{digit})+
other_chars          [.,_:]
whitespace [ \t]
newline [\n]
bool 0|1
prefix ss:
start_tag  \<{prefix}{word}\>
closing_tag \<\/{prefix}{word}\>
self_closing_tag \<{prefix}{word}\/\>
attribute  {prefix}{word}\=\"{alphar}\"
tag_with_attr (\<{prefix}{word}(\ {attribute})+\>)|(\<{prefix}{word}(\ {attribute})+\/\>)
comment \<\!\-\-((\ )|({alphar}))+\-\-\>
content ({alphar}|{other_chars}|{alphar}{whitespace}|{other_chars}{whitespace})+

Workbook_start_tag "<"{prefix}"Workbook>"
Workbook_closing_tag "</"{prefix}"Workbook>"

Styles_start_tag "<"{prefix}"Styles>"
Styles_closing_tag "</"{prefix}"Styles>"
Styles_self_closing_tag "<"{prefix}"Styles/>"

Style_Attribute \ {prefix}"ID="{alphar}
Style_start_tag "<"{prefix}Style"{Style_Attribute}{1}">"
Style_closing_tag "</"{prefix}"Style>"
Style_self_closing_tag "<"{prefix}"Style"{Style_Attribute}{1}"/>"

Worksheet_attributes (\ {prefix}"Name="{alphar}){1}(\ {prefix}"Protected="{bool})?
Worksheet_start_tag "<"{prefix}"Worksheet"{Worksheet_attributes}">" 
Worksheet_closing_tag "</"{prefix}"Worksheet>"
Worksheet_self_closing_tag "<"{prefix}"Worksheet "{Worksheet_attributes}"/>"

Table_attributes ((\ {prefix}"ExpandedColumnCount="{number})
                    |(\ {prefix}"ExpandedRowCount="{number})
                    |(\ {prefix}"StyleID="{alphar}))*
Table_start_tag "<"{prefix}"Table"{Table_attributes}">"
Table_closing_tag "</"{prefix}"Table>"
Table_self_closing_tag "<"{prefix}"Table"{Table_attributes}"/>"

Column_attributes ((\ {prefix}"Hidden="{bool})
                    |(\ {prefix}"Width="{number})
                    |(\ {prefix}"StyleID="{alphar}))*
Column_self_closing_tag "<"{prefix}"Column"{Column_attributes}"/>"

Row_attributes ((\ {prefix}"Height="{number})
                    |(\ {prefix}"Hidden="{bool})
                    |(\ {prefix}"StyleID="{alphar}))*
Row_start_tag "<"{prefix}"Row"{Row_attributes}">"
Row_closing_tag "</"{prefix}"Row>"
Row_self_closing_tag "<"{prefix}"Row"{Row_attributes}"/>"

Cell_attributes ((\ {prefix}"MergeAcross="{number})
                    |(\ {prefix}"MergeDown="{number})
                    |(\ {prefix}"StyleID="{alphar}))*
Cell_start_tag "<"{prefix}"Cell"{Cell_attributes}">"
Cell_closing_tag "</"{prefix}"Cell>"
Cell_self_closing_tag "<"{prefix}"Cell"{Cell_attributes}"/>"

Data_start_tag "<"{prefix}"Data "{prefix}"Type="("Number")
                    |("DateTime")
                    |("Boolean")
                    |("String")">"
Data_closing_tag "</"{prefix}"Data>"
Data_self_closing_tag "<"{prefix}"Data "{prefix}"Type="("Number")
                    |("DateTime")
                    |("Boolean")
                    |("String")"/>"
%%

{start_tag} {return START_TAG;}
{closing_tag} {return CLOSING_TAG;}
{self_closing_tag} {return SELF_CLOSING_TAG}
{attribute} {printf(" ^^^^attribute^^^^ ");}
{tag_with_attr} {printf(" ^^^^tag with attr^^^^ ");}
"<!--"[^-]*"-->" {printf(" ^^^^COMMENT^^^^ ");}
{content} {return CONTENT;}
%%

