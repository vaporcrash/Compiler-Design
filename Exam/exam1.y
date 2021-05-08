%{
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  int yylex(void);
  int yyerror(char *);
  int flag = 0;
  int label=0;
%}

%token NUM ASSIGN ID
%token RELOP LOGIC ARTHOP UNAR NOT

%right '*' '/'
%left '+' '-'

%%
Lines : Line Lines
      | Line
Line : assn
     | '{' Line '}'
     ;

assn : ID ASSIGN expr{printf("%s",$3);}
      ;

expr : ID ARTHOP expr {sprintf($$,"%s %s %s",$1,$2,$3);}
     | ID UNAR
     | UNAR ID
     | ID
     | NUM
     ;

%%

int yyerror(char *s){
  flag=1;
  return 1;
}

int main(void){
  printf("\nSyntax Checker\n");
  printf("Input: \n");
  system("cat input.txt");
  FILE *fp = fopen("input.txt","r+");
  yyparse();
  fclose(fp);
  if(flag==1)
  {
    printf("\nSyntactically incorrect\n");
  }
  else
  {
    printf("\nSyntactically Correct\n");
  }
  return 0;
}
