%{
#include<stdio.h>
#include<stdlib.h>
#include "y.tab.c"
void yyerror(char *);
int yylex(void);
int yylval;
%}

GT ">="
LT "<="
AND "&&"
OR "||"
EQ "=="
NEQ"!="
LS "<<"
RS ">>"

%%
[0-9]+ {yylval=atoi(yytext); return NUM;}
['+'|'-'|'*'|'/'|'%'|'^'] {return (*yytext);}
[\t];
[\n] return 0;
	 . return yytext[0];
{GT} {return GT;}
{LT} {return LT;}
{AND} {return AND;}
{OR} {return OR;}
{NEQ} {return NEQ;}
{EQ} {return EQ;}
{LS} {return LS;}
{RS} {return RS;}
%%

int yywrap(void)
{
	return 1;
}
