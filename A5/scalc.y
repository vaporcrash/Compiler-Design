%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int yylex(void);
void yyerror(char *);
int flag=0;
%}

%token NUM GT LT RS LS AND EQ NEQ OR

%left OR
%left AND
%left '|'
%left '&'
%left EQ NEQ
%left '>' GT
%left '<' LT
%left LS RS
%left '+' '-'
%left '*' '/' '%'
%left '^'
%left '(' ')'
%%
Result: E {printf("Calculated Result=%d",$$);};
E:    E '+' E {$$=$1+$3;}
	| E '-' E {$$ = $1 - $3;}
	| E '*' E {$$=$1*$3;}
	| E '/' E {$$=$1/$3;}
	| E '%' E {$$=$1%$3;}
	| E '^' E {$$=pow($1,$3);}
	|'('E')' {$$=$2;}
	| E GT E {$$ = $1>= $3; }
	| E '>' E {$$ = $1> $3; }
	| E '<' E {$$ = $1< $3; }
	| E LT E {$$ = $1<= $3; }
	| E RS E {$$ = $1>>$3; }
	| E EQ E {$$ = $1==$3;}
	| E NEQ E {$$ = $1!=$3;}
	| E LS E {$$ = $1<< $3; }
	| E '&' E {$$ = $1 & $3; }
	| E '|' E {$$ = $1 | $3; }
	| E AND E {$$ = $1 && $3; }
	| E OR E {$$ = $1 || $3; }
	| NUM {$$ = $1;}
;
%%

int main()
{
	printf("\nEnter expression: ");
	yyparse();
	if(flag==0)
			printf("\nEntered expression is valid\n\n");
	return 0;
}

void yyerror(char * str)
{
printf("\nEntered expression is invalid\n\n");
flag=1;

}
