%{
  #include<stdio.h>
  #include<stdlib.h>
  #include<string.h>
  int yylex(void);
  int yyerror(char *s);
  int flag=0;
%}

%token NUM ASSIGN ID
%token IF ELSEIF ELSE
%token FOR WHILE
%token RELOP LOGIC ARTHOP UNI NOT

%%
stmts : bl stmts
      | bl
      ;

bl    : loop '{' bl
      | condstmt '{' bl
      | expression ';'
      | '}'
      ;

loop  : FOR '(' expression ';' condition ';' expression ')'
      | FOR '(' ';' condition ';' ')'
      | WHILE '(' condition ')'
      ;

condstmt : IF '(' condition ')'
      | ELSEIF '(' condition ')'
      | ELSE
      ;

condition : condn LOGIC condition
      | condn
      ;

condn : ID RELOP ID
      | ID RELOP NUM
      | NOT ID
      | ID
      ;

expression : init
      | ID ASSIGN ID ARTHOP ID
      | ID ASSIGN ID ARTHOP NUM
      | ID ASSIGN NUM ARTHOP ID
      | ID ASSIGN NUM ARTHOP NUM
      | ID UNI
      | UNI ID
      ;

init : ID ASSIGN init
     | ID ASSIGN ID
     | ID ASSIGN NUM
     ;

%%

int yyerror(char *s)
{
  flag=1;
  return 1;
}

int main(void){
printf("\nSyntax Checker\n");
FILE *fp = fopen("file.txt","r+");
yyparse();
fclose(fp);
if(flag==1){
  printf("\nSyntactically Incorrect\n");
}
else{
  printf("\nSyntactically Correct\n");
}
return 0;
}
