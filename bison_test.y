%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int errorCount = 0; 
int yylex();
void yyerror(char *);
extern FILE *yyin;
extern FILE *yyout;
%}

%token CONTENT
%token COMMENT
%token WsT
%token WBsT
%token WcT
%token WBcT
%token WscT
%token SA
%token SsT
%token ScT
%token SscT
%token SSsT
%token SScT
%token SSscT
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

%%

text: CONTENT  | ;
data_element: DsT text DcT 
                | DscT { fprintf("HELO"); }
;

%%

void yyerror (char *s)
{
    errorCount++;
    fprintf(stderr,"%s on line \n",s); /*here I get the info about errors */
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