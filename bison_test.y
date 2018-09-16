%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int errorCount = 0; 
extern int line_number;
int yylex();
void yyerror(char *);
extern FILE *yyin;
extern FILE *yyout;
%}
%start WorkbookElement
%token WsT
%token WBsT
%token WcT
%token WBcT
%token WscT
%token SA
%token SsT
%token ScT
%token SscT
%token StylescT
%token StylessT
%token StylesscT
%token WA
%token TA
%token TsT
%token TcT
%token TscT
%token RA
%token RsT
%token RcT
%token RscT
%token CA
%token CscT
%token CEA
%token CEsT
%token CEcT
%token CEscT
%token DsT
%token DcT
%token DscT
%token COMMENT

%%
DataElement: DsT  DcT 
                | DscT
                | DataElement  DsT  DcT  
                | DataElement  DscT
CellElement: CEsT  DataElement  CEcT 
                | CEscT
                | CellElement  CEsT  DataElement  CEcT 
                | CellElement  CEscT
                | CEsT CEcT 
                | CellElement  CEsT CEcT;
RowElement: RsT  CellElement  RcT 
                | RscT
                | RowElement  RsT  CellElement  RcT 
                | RowElement  RscT
                | RsT RcT 
                | RowElement  RsT RcT;
ColumnElement: CscT
                | ColumnElement  CscT;
TableElement: TsT  ColumnElement  RowElement  TcT
                | TsT ColumnElement TcT
                | TsT RowElement TcT
                | TscT
                | TsT TcT
                | TableElement  TsT  ColumnElement  RowElement  TcT
                | TableElement  TsT  ColumnElement  TcT
                | TableElement  TsT  RowElement  TcT
                | TableElement  TscT
                | TableElement  TsT TcT;
WorksheetElement: WsT  TableElement  WcT
                | WscT
                | WorksheetElement  WsT  TableElement  WcT
                | WorksheetElement  WscT
                | WsT WcT
                | WorksheetElement  WsT WcT;
StyleElement: SsT  ScT
                | SscT
                | StyleElement  SsT  ScT
                | StyleElement  SscT;
StylesElement: StylessT  StyleElement  StylescT
                | StylesscT
                | StylessT  StylescT
                | StylesElement  StylessT  StyleElement  StylescT
                | StylesElement  StylesscT
                | StylesElement  StylessT  StylescT;
WorkbookElement: WBsT  StylesElement  WorksheetElement  WBcT
                | WBsT  WorksheetElement  WBcT;


%%

void yyerror (char *s)
{
    errorCount++;
    fprintf(stderr,"%s on line %d \n",s,line_number); /*here I get the info about errors */
}

int main(int argc, const char **argv)
{
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
    } else {
        yyin = stdin;
    }

    int result;

    if ((result = yyparse()) == 0) {   
        printf("No syntax errors\n");
    } else {
        printf("\nFound %d syntax errors\n",errorCount);
    }
    return 0;
}