%{
  #include<stdio.h>
  #define YYSTYPE double
  int flag=0;
  int yylex(void);
  int yyerror();
  double pow(double x, double y){
  double pdt=1.0;
  while(y--){
    pdt*=x;
  }
  return pdt;
  }
  int op=0;
%}

%token NUM


%left '+' '-'
%left '*' '/' '%'
%left '(' ')'

%%
P : E {printf("\nResult: %lf\n",$$);}
E : E '+' E {$$ = $1+$3;}
  | E '-' E {$$ = $1-$3;}
  | E '*' E {$$ = $1*$3;}
  | E '/' E {$$=$1/$3;}
  | '('E')' {$$=$2;}
  | NUM {$$=$1;}
%%

int yyerror()
{
    printf("\nInvalid\n");
    flag=1;
}

int main(void){
printf("Enter\n");
yyparse();
if(flag==0)
  printf("Valid\n");
return 0;
}
