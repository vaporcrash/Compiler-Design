%option noyywrap
%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h"
//extern int yylval;

%}

datatype    "int"|"real"|"char"
if          "IF"|"if"
then        "THEN"|"then"
endif       "ENDIF"|"endif"
else        "ELSE"|"else"

letter      [a-zA-Z]
letters     {letter}+
digit       [0-9]
digits      [+-]?{digit}+
optfrac     [.]{digits}
optexp      [E][+-]?{digits}
numconst    {digits}({optfrac}|{optexp})?
charconst   [']{letter}[']
strconst    ["]{letters}["]

id          {letter}({letters}|{digits})?
arithop     ("+"|"-"|"*"|"/"|"%")
relop       ("<="|">="|">"|"<"|"=="|"!=")
logop       ("&&"|"||"|"!")
newl        [\n]
tabs        [\t]
spaces      [ ]

%%
{if}            { return IF;}
{then}          { return THEN;}
{else}          { return ELSE;}
{endif}         { return ENDIF;}
{datatype}      { return DT;}
{id}            { yylval.str = strdup(yytext);  return ID;}
{numconst}      { yylval.str = strdup(yytext);    return NUMCONST;}
{charconst}     { yylval.chr = yytext[0];       return CHARCONST;}
{strconst}      { yylval.str = strdup(yytext);  return STRCONST;}
{arithop}       { yylval.str = strdup(yytext);  return ARITHOP;}
{relop}         { yylval.str = strdup(yytext);  return RELOP;}
{logop}         { yylval.str = strdup(yytext);  return LOGOP;}
{spaces}        {};
{newl}          {};
{tabs}          {};
.               {return *yytext;};
%%
