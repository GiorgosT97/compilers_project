%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int line_number = 1;
%}
%option noyywrap

letter [a-zA-Z]
word   {letter}{letter}+
digit  [0-9]
number \"({digit}+)\"
alphar (({letter}|{digit})+)|(\"({letter}|{digit})+\")
other_chars [.,_:]
whitespace [ \t]
newline [\n]
bool 0|1
prefix "ss:"

Workbook_start_tag "<"{prefix}"Workbook>"
Workbook_closing_tag "</"{prefix}"Workbook>"

Styles_start_tag "<"{prefix}"Styles>"
Styles_closing_tag "</"{prefix}"Styles>"
Styles_self_closing_tag "<"{prefix}"Styles/>"

Style_Attribute \ {prefix}"ID="{alphar}
Style_start_tag "<"{prefix}"Style"{Style_Attribute}{1}">"(({alphar})|({whitespace}))*
Style_closing_tag "</"{prefix}"Style>"
Style_self_closing_tag "<"{prefix}"Style"{Style_Attribute}{1}"/>"

Worksheet_attributes (\ {prefix}"Name="{alphar}){1}(\ {prefix}"Protected="{bool})?
Worksheet_start_tag "<"{prefix}"Worksheet"{Worksheet_attributes}">"(({alphar})|({whitespace}))* 
Worksheet_closing_tag "</"{prefix}"Worksheet>"
Worksheet_self_closing_tag "<"{prefix}"Worksheet"{Worksheet_attributes}"/>"

Table_attributes ((\ {prefix}"ExpandedColumnCount="{number})|(\ {prefix}"ExpandedRowCount="{number})|(\ {prefix}"StyleID="{alphar}))*
Table_start_tag "<"{prefix}"Table"{Table_attributes}">"(({alphar})|({whitespace}))*
Table_closing_tag "</"{prefix}"Table>"
Table_self_closing_tag "<"{prefix}"Table"{Table_attributes}"/>"

Column_attributes ((\ {prefix}"Hidden="{bool})|(\ {prefix}"Width="{number})|(\ {prefix}"StyleID="{alphar}))*
Column_self_closing_tag "<"{prefix}"Column"{Column_attributes}"/>"

Row_attributes ((\ {prefix}"Height="{number})|(\ {prefix}"Hidden="{bool})|(\ {prefix}"StyleID="{alphar}))*
Row_start_tag "<"{prefix}"Row"{Row_attributes}">"(({alphar})|({whitespace}))*
Row_closing_tag "</"{prefix}"Row>"
Row_self_closing_tag "<"{prefix}"Row"{Row_attributes}"/>"

Cell_attributes ((\ {prefix}"MergeAcross="{number})|(\ {prefix}"MergeDown="{number})|(\ {prefix}"StyleID="{alphar}))*
Cell_start_tag "<"{prefix}"Cell"{Cell_attributes}">"(({alphar})|({whitespace}))*
Cell_closing_tag "</"{prefix}"Cell>"
Cell_self_closing_tag "<"{prefix}"Cell"{Cell_attributes}"/>"

Data_attributes \ {prefix}"Type="\"(("String")|("Number")|("Boolean")("Datetime"))\"
Data_start_tag "<"{prefix}"Data"{Data_attributes}">"(({alphar})|({whitespace}))*
Data_closing_tag "</"{prefix}"Data>"
Data_self_closing_tag "<"{prefix}"Data"{Data_attributes}"/>"

%%
{whitespace} {printf(" ");} 
{newline} {printf("\n"); line_number++;}
{Workbook_start_tag} {printf("%s", yytext); return WBsT;}  
{Workbook_closing_tag} {printf("%s", yytext); return WBcT;}
{Styles_start_tag} {printf("%s", yytext); return StylessT;}
{Styles_closing_tag} {printf("%s", yytext); return StylescT;}
{Styles_self_closing_tag} {printf("%s", yytext); return StylesscT;}
{Style_Attribute} {printf("%s", yytext); return SA;}
{Style_start_tag} {printf("%s", yytext); return SsT;}
{Style_closing_tag} {printf("%s", yytext); return ScT;}
{Style_self_closing_tag} {printf("%s", yytext); return SscT;}
{Worksheet_attributes} {printf("%s", yytext); return WA;}
{Worksheet_start_tag} {printf("%s", yytext); return WsT;} 
{Worksheet_closing_tag} {printf("%s", yytext); return WcT;}
{Worksheet_self_closing_tag} {printf("%s", yytext); return WscT;}
{Table_attributes} {printf("%s", yytext); return TA;}
{Table_start_tag} {printf("%s", yytext); return TsT;}
{Table_closing_tag} {printf("%s", yytext); return TcT;}
{Table_self_closing_tag} {printf("%s", yytext); return TscT;}
{Column_attributes} {printf("%s", yytext); return CA;}
{Column_self_closing_tag} {printf("%s", yytext); return CscT;}
{Row_attributes} {printf("%s", yytext); return RA;}
{Row_start_tag} {printf("%s", yytext); return RsT;}
{Row_closing_tag} {printf("%s", yytext); return RcT;}
{Row_self_closing_tag} {printf("%s", yytext); return RscT;}
{Cell_attributes} {printf("%s", yytext); return CEA;}
{Cell_start_tag} {printf("%s", yytext); return CEsT;} 
{Cell_closing_tag} {printf("%s", yytext); return CEcT;} 
{Cell_self_closing_tag} {printf("%s", yytext); return CEscT;} 
{Data_start_tag} {printf("%s", yytext); return DsT;} 
{Data_closing_tag} {printf("%s", yytext); return DcT;} 
{Data_self_closing_tag} {printf("%s", yytext); return DscT;} 

"<!--"[^-]*(-[^-]+)*"-->" {printf("%s", yytext);}

%%

