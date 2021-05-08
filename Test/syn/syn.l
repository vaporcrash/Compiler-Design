%{
  #include<stdio.h>
  #include<stdlib.h>
  #include "y.tab.h"
  int yylval;
  int yylex(void);
  void yyerror(char *);
%}

assign ("=")
relop ("=="|"!="|">"|"<"|">="|"<=")
arthop ("+"|"-"|"/"|"*"|"%")
uni ("++"|"--")
logic ("&&"|"||")
not ("!")
id [a-zA-Z_][a-zA-Z0-9_]*

%%
[0-9]+ {return NUM;}
{assign} {return ASSIGN;}
{relop} {return RELOP;}
{arthop} {return ARTHOP;}
{uni} {return UNI;}
{logic} {return LOGIC;}
"if" {return IF;}
"else if" {return ELSEIF;}
"else" {return ELSE;}
"for" {return FOR;}
"while" {return WHILE;}
{id} {return ID;}
[\t\n] {;}
. {return *yytext;}
%%

int yywrap(void){
  return 1;
}
