%{
  #include <stdio.h>
  #include <stdlib.h>
  #include "y.tab.c"
  #include "y.tab.h"
  int yylex(void);
  int yylval;
%}

assign "="
relop ("=="|"!="|">"|"<"|">="|"<=")
arthop ("+"|"-"|"*"|"/"|"%")
unar ("++"|"--")
not ("!")
logic ("&&"|"||")
id [a-zA-Z_][a-zA-Z0-9_]*

%%
[0-9]+ {return NUM;}
{assign} {return ASSIGN;}
{relop} {return RELOP;}
{logic} {return LOGIC;}
{arthop} {return ARTHOP;}
{unar} {return UNAR;}
{not} {return NOT;}
{id} {return ID;}
[ \t\n] {;}
. {return *yytext;}

%%

int yywrap(void)
{
  return 1;
}
