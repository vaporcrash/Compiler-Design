%{
  #include<stdio.h>
	#include<stdlib.h>
	#include "y.tab.h"
	void yyerror(char *);
	int yylex(void);
	int yylval;  
%}

assign      ("=")
relop       ("=="|"!="|">="|"<="|"<"|">")
arithop     ("+"|"-"|"/"|"%"|"*")
inde      ("++"|"--")
logical     ("||"|"&&")
id  [a-zA-Z_][a-zA-Z0-9_]*


%%

[0-9]+          {return NUM;}
{assign}        {return ASSIGN;}
{relop}         {return RELOP;}
{logical}       {return LOGIC;}
{arithop}       {return ARITH;}
{inde}          {return INDE;}
"if"            {return IF;}
"else if"       {return ELSEIF;}
"else"          {return ELSE;}
"for"           {return FOR;}
"while"         {return WHILE;}
{id}    		{return ID;}


[ \t]           {;}
[\n]            {;}
.               {return *yytext;}

%%

int yywrap(void)
{
   return 1;
}
