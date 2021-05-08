%{
#include<stdio.h>
#include<string.h>


char dtype[10][10];
char varname[10][10];
char size[10][10];
int addr[10];
char val[10][10];

int dtrack=0;
int nametrack=0;
int valtrack=0;

int start_addr = 1000;

int isAdded(int idx, char *str) {
	for(int i = 0; i<idx; i++) {
		if(strcmp(varname[i], str) == 0) {
			return 1;
		}
		else return 0;
	}
}
%}

keyword "if"|"else"|"while"|"for"|"do"|"break"|"switch"|"continue"|"return"|"case"|"default"|"void"|"int"|"char"|"bool"|"struct"|"goto"|"typedef"|"unsigned"|"long"|"short"|"float"|"double"|"sizeof"
numconst [-+]?[0-9]+(\.[0-9]+)?
charconst '.'
strconst '.*'
func [a-zA-Z ][a-zA-Z0-9 ]*[(].*[)]
iden [a-zA-Z ][a-zA-Z0-9 ]*
ppdr #.*
relop ">="|"<="|"=="|"!="|">"|"<"
arthop "+"|"."|"*"|"%"|"/"
logicop "&&"|"\"|"!"
opasn "+="|"-="|"*="|"/="|"%="
assn "="
sngcmt [/][/].*
mltcmt \/\*(.*\n?)*\*\/

/* Rules Section*/
%%
{ppdr} {printf("PD ");}
{keyword} {
if (strcmp(yytext, "int") == 0) {
  strcpy(dtype[dtrack], "int");
  strcpy(size[dtrack], "2");
  start_addr += 2;
  addr[dtrack] = start_addr;
}

else if (strcmp(yytext, "float") == 0) {
  strcpy(dtype[dtrack], "float");
  strcpy(size[dtrack], "4");
  start_addr += 4;
  addr[dtrack] = start_addr;
}
else if (strcmp(yytext, "char") == 0) {
  strcpy(dtype[dtrack], "char");
  strcpy(size[dtrack], "1");
  start_addr += 1;
  addr[dtrack] = start_addr;
}

dtrack++;
printf("KW ");
}
{func} {printf("FC ");}
{numconst} {strcpy(val[valtrack],yytext);printf("NUMCONST ");valtrack++;}
{charconst} {strcpy(val[valtrack],yytext);valtrack++;printf("CHARCONST ");}
{strconst} {printf("STRCONST ");}
{relop} {printf("RELOP ");}
{opasn} {printf("ASSIGN ");}
{arthop} {printf("ARTHOP ");}
{assn} {printf("ASSIGN ");}
{iden} {
  if(!isAdded(nametrack,yytext)){
  strcpy(varname[nametrack],yytext);
  nametrack++;
  }
printf("ID ");}
[,{}();] {
  if(valtrack != nametrack){
  strcpy(val[valtrack],"NA");
  valtrack++;
  }
printf("SP ");}
{sngcmt} {printf("SINGLECMT");}
{mltcmt} {printf("MULTICMT");}
. {}
\n {printf("\n");}

%%

int yywrap(void){}

int main()
{
    extern FILE *yyin;
    char* name = (char*)calloc(100,sizeof(char));
    printf("Enter File name: ");
    scanf("%[^\n]",name);
    yyin = fopen(name, "r+");
    yylex();
    printf("\t\tSYMBOL TABLE\n");
    for(int i=0; i<nametrack-1; i++) {
      printf("\t%s\t%s\t%d\t%s\t%s\n", varname[i], dtype[i], addr[i], size[i], val[i]);
    }
    printf("\n");

    return 0;
}
