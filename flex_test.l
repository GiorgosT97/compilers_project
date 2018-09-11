
letter [a-zA-Z]
word   {letter}{letter}+
digit  [0-9]
number {digit}{digit}+
other_chars          [.,_:]
prefix ss:
start_tag  \<{prefix}{word}\>
closing_tag \<\/{prefix}{word}\>
self_closing_tag \<{prefix}{word}\/\>
attribute  {prefix}{word}\=\"{word}\"
attributes {attribute}[\ {attribute}]+
%%

{start_tag} {printf("Tag Open");}
{closing_tag} {printf("Tag CLose ");}
{self_closing_tag} {printf("Tag Self Closing ");}
{attribute} {printf("attribute ");}
{attributes} {printf("attributes ");}

%%

void main()
{
   
    yyin = stdin;
    yylex();


}							    
