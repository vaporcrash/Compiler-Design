%{
#include<stdio.h>
#include<string.h>
int i = 0;
%}
zero [0]
digit [+-]?[0-9]+
/* Rules Section*/
%%
{zero} {printf("Count: %d", i);}
{digit} {if(atoi(yytext) > 0){i++;}}
%%

int yywrap(void){}

int main()
{
    // The function that starts the analysis
    yylex();

    return 0;
}
