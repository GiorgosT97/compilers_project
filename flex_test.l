%{
#include "bison_test.tab.h"

%}
%option noyywrap

letter [a-zA-Z]
word   {letter}{letter}+
digit  [0-9]
number {digit}{digit}+
alphar ({letter}|{digit})+
other_chars [.,_:]
whitespace [ \t]
newline [\n]
bool 0|1
prefix ss:

content ({alphar}|{other_chars}|{alphar}{whitespace}|{other_chars}{whitespace})+

Workbook_start_tag "<"{prefix}"Workbook>"
Workbook_closing_tag "</"{prefix}"Workbook>"

Styles_start_tag "<"{prefix}"Styles>"
Styles_closing_tag "</"{prefix}"Styles>"
Styles_self_closing_tag "<"{prefix}"Styles/>"

Style_Attribute \ {prefix}"ID="{alphar}
Style_start_tag "<"{prefix}"Style"{Style_Attribute}{1}">"
Style_closing_tag "</"{prefix}"Style>"
Style_self_closing_tag "<"{prefix}"Style"{Style_Attribute}{1}"/>"

Worksheet_attributes (\ {prefix}"Name="{alphar}){1}(\ {prefix}"Protected="{bool})?
Worksheet_start_tag "<"{prefix}"Worksheet"{Worksheet_attributes}">" 
Worksheet_closing_tag "</"{prefix}"Worksheet>"
Worksheet_self_closing_tag "<"{prefix}"Worksheet "{Worksheet_attributes}"/>"

Table_attributes ((\ {prefix}"ExpandedColumnCount="{number})|(\ {prefix}"ExpandedRowCount="{number})|(\ {prefix}"StyleID="{alphar}))*
Table_start_tag "<"{prefix}"Table"{Table_attributes}">"
Table_closing_tag "</"{prefix}"Table>"
Table_self_closing_tag "<"{prefix}"Table"{Table_attributes}"/>"

Column_attributes ((\ {prefix}"Hidden="{bool})|(\ {prefix}"Width="{number})|(\ {prefix}"StyleID="{alphar}))*
Column_self_closing_tag "<"{prefix}"Column"{Column_attributes}"/>"

Row_attributes ((\ {prefix}"Height="{number})|(\ {prefix}"Hidden="{bool})|(\ {prefix}"StyleID="{alphar}))*
Row_start_tag "<"{prefix}"Row"{Row_attributes}">"
Row_closing_tag "</"{prefix}"Row>"
Row_self_closing_tag "<"{prefix}"Row"{Row_attributes}"/>"

Cell_attributes ((\ {prefix}"MergeAcross="{number})|(\ {prefix}"MergeDown="{number})|(\ {prefix}"StyleID="{alphar}))*
Cell_start_tag "<"{prefix}"Cell"{Cell_attributes}">"
Cell_closing_tag "</"{prefix}"Cell>"
Cell_self_closing_tag "<"{prefix}"Cell"{Cell_attributes}"/>"

Data_start_tag "<"{prefix}"Data "{prefix}"Type="("Number")|("DateTime")|("Boolean")|("String")">"
Data_closing_tag "</"{prefix}"Data>"
Data_self_closing_tag "<"{prefix}"Data "{prefix}"Type="("Number")|("DateTime")|("Boolean")|("String")"/>"
%%

{Workbook_start_tag} {return WBsT;}  
{Workbook_closing_tag} {return WBcT;}
{Styles_start_tag} {return SStT;}
{Styles_closing_tag} {return SScT;}
{Styles_self_closing_tag} {return SSscT;}
{Style_Attribute} {return SA;}
{Style_start_tag} {return SsT;}
{Style_closing_tag} {return ScT;}
{Style_self_closing_tag} {return SscT;}
{Worksheet_attributes} {return WA;}
{Worksheet_start_tag} {return WsT;} 
{Worksheet_closing_tag} {return WcT;}
{Worksheet_self_closing_tag} {return WscT;}
{Table_attributes} {return TA;}
{Table_start_tag} {return TsT;}
{Table_closing_tag} {return TcT;}
{Table_self_closing_tag} {return TscT;}
{Column_attributes} {return CA;}
{Column_self_closing_tag} {return CscT;}
{Row_attributes} {return RA;}
{Row_start_tag} {return RsT;}
{Row_closing_tag} {return RcT;}
{Row_self_closing_tag} {return RscT;}
{Cell_attributes} {return CEA;}
{Cell_start_tag} {return CEsT;} 
{Cell_closing_tag} {return CEcT;} 
{Cell_self_closing_tag} {return CEscT;} 
{Data_start_tag} {return DsT;} 
{Data_closing_tag} {return DcT;} 
{Data_self_closing_tag} {return DscT;} 

"<!--"[^-]*"-->" {return COMMENT;}
{content} {return CONTENT;}
%%

