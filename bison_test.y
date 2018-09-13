%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int errorCount = 0; 
extern int lineNumber;
int yylex();
void yyerror(char *);
extern FILE *yyin;
extern FILE *yyout;
%}

%start WorkbookElement
%token START_TAG


%%
text : KEIMENO | ;
StyleElement : START STYLE ID CLOSE START SLASH STYLE CLOSE ;
Stylescontext : text StyleElement text ;
StylesElement : START STYLES CLOSE Stylescontext START CLOSINGSTYLE CLOSE | START STYLES SLASH CLOSE | START STYLES CLOSE text START SLASH STYLES CLOSE ;
Workbookcontext : text StylesElement text ; 
WorkbookElement : START WORKBOOK CLOSE Workbookcontext START SLASH WORKBOOK CLOSE | START WORKBOOK SLASH CLOSE ;
%%

void yyerror (char *s)
{
    errorCount++;
    fprintf(stderr,"%s on line %d \n",s,lineNumber); /*here I get the info about errors */
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