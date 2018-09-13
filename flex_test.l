
%option noyywrap

letter [a-zA-Z]
word   {letter}{letter}+
digit  [0-9]
number {digit}{digit}+
alphar ({letter}|{digit})+
other_chars          [.,_:]
whitespace [ \t]
newline [\n]
prefix ss:
start_tag  \<{prefix}{word}\>
closing_tag \<\/{prefix}{word}\>
self_closing_tag \<{prefix}{word}\/\>
attribute  {prefix}{word}\=\"{alphar}\"
tag_with_attr (\<{prefix}{word}(\ {attribute})+\>)|(\<{prefix}{word}(\ {attribute})+\/\>)
comment \<\!\-\-((\ )|({alphar}))+\-\-\>
content ({alphar}|{other_chars}|{alphar}{whitespace}|{other_chars}{whitespace})+
%%

{start_tag} {printf("^^^^START TAG^^^^");}
{closing_tag} {printf(" ^^^^Tag CLose^^^^ ");}
{self_closing_tag} {printf(" ^^^^Tag Self Closing^^^^ ");}
{attribute} {printf(" ^^^^attribute^^^^ ");}
{tag_with_attr} {printf(" ^^^^tag with attr^^^^ ");}
"<!--"[^-]*"-->" {printf(" ^^^^COMMENT^^^^ ");}
{content} {printf("CONTENT");}
%%

void main(int argc, char ** argv)
{
   
    yyin = fopen(argv[1], "r");
    yylex();


}							    
