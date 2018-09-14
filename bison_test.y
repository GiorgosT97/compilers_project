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
%token CONTENT
%token COMMENT
%token NewLine

%%

line: NewLine;
DataElement: DsT line DcT 
                | DscT;
CellElement: CEsT line DataElement line CEcT 
                | CEscT;
RowElement: RsT line CellElement line RcT 
                | RscT;
ColumnElement: CscT;
TableElement: TsT line ColumnElement line RowElement line TcT
                | TsT line ColumnElement line TcT
                | TsT line RowElement line TcT
                | TscT;
WorksheetElement: WsT line TableElement line WcT
                | WscT;
StyleElement: SsT line ScT
                | SscT;
StylesElement: StylessT line StyleElement line StylescT
                | StylesscT
                | StylessT line StylescT;
WorkbookElement: WBsT line StylesElement line WorksheetElement line WBcT
                | WBsT line WorksheetElement line WBcT;


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