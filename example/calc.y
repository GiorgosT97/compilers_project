
%{
#include <stdio.h>
#include <math.h>
void yyerror(char *); 
extern FILE *yyin;								
extern FILE *yyout;								
%}
	    
%token INT
%left '+' 
%left '*' 
%%

program: expr  			  { fprintf(yyout, "%i\n", $1); }
         ;
				    
expr:  	  INT
	| expr '+' expr           { $$ = $1 + $3; }
	| expr '*' expr           { $$ = $1 * $3; }
	;
								    
%%								    
    

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}									


int main ( int argc, char **argv  ) 
  {
  ++argv; --argc;
  if ( argc > 0 )
        yyin = fopen( argv[0], "r" );
  else
        yyin = stdin;
  yyout = fopen ( "output", "w" );	
  yyparse ();	    
  return 0;
  }   
										