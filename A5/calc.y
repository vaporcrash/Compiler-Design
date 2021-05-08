%{
    #include<stdio.h>
    #define YYSTYPE double
    int flag = 0;
    int yyerror();
    int yylex(void);

    double pow(double x, double y){
        double pdt = 1.0;
        while(y--){
            pdt *= x;
        }
        return pdt;
    }
    int op = 0;

%}

%token  NUM
%left '|'
%left '&'
%right '!'

%left '>' '<'
%left '+' '-'
%left '/' '*' '%'
%right '^'
%left '(' ')'

%%
P : E {printf("\nResult: %lf\n", $$);}
E : E '+' E {$$ = $1 + $3;}
  | E '-' E {$$ = $1 - $3;}
  | E '*' E {$$ = $1 * $3;}
  | E '/' E {$$ = $1 / $3;}
  | E '^' E {$$ = pow($1, $3);}
  |'('E')' {$$=$2;}
  | NUM {$$ = $1;}

E : E AND E {$$ = $1 * $3;}
  | E OR E {if($1==1||$3 ==1){$$=1;}else{$$=0;}}
  | NOT E { if($2==1){ $$=0; }else{ $$=1;}}

AND : '&''&'
OR : '|''|'
NOT : '!'

E : E LSHIFT E {$$ = (int)$1 << (int)$3;}
  | E RSHIFT E {$$ = (int)$1 >> (int)$3;}
  | E BAND E {$$ = (int)$1 & (int)$3;}
  | E BOR E {$$ = (int)$1 | (int)$3;}
  | BNOT E {$$ = ~(int)$1;}

LSHIFT : '<''<'
RSHIFT : '>''>'
BAND : '&'
BOR : '|'
BNOT : '~'

E : E GR E {if($1 > $3){$$=1;} else{$$=0;}}
  | E GRE E {if($1 >= $3){$$=1;} else{$$=0;}}
  | E LE E {if($1 < $3){$$=1;} else{$$=0;}}
  | E LEE E {if($1 <= $3){$$=1;} else{$$=0;}}
  | E EQ E {if($1 == $3){$$=1;} else{$$=0;}}
  | E NEQ E {if($1 != $3){$$=1;} else{$$=0;}}

GR : '>'
GRE : '>''='
LE : '<'
LEE : '<''='
EQ : '=''='
NEQ : '!''='


;
%%
int yyerror ()
{
    printf("\nEntered expression is invalid\n\n");
   flag=1;

}

int main (void){
    printf("\nEnter expression: ");
    yyparse();
    if(flag==0)
        printf("\nEntered expression is valid\n\n");
    return 0;
}
/*
yacc -d calc.y
lex calc.l
gcc lex.yy.c (or) gcc y.tab.c lex.yy.c -w
./a.out
*/
