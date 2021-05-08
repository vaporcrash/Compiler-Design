%{
#include <stdio.h>
#include <math.h>
int flag = 0;
void p();
void a();
void g();
void gm();
int yyerror();
%}

%token NUM ID ASSIGN
%token RELOP LOGIC ARTHOP UNAR NOT
%right '='
%right '/' '*'
%left '+' '-'
%left '(' ')'

%%
Lines : Line Lines
      | Line
Line : Expr
     | '{' Line '}'
Expr : Expr '+' {p();} Expr {g();}
     | Expr '-' {p();} Expr {g();}
     | Expr '*' {p();} Expr {g();}
     | Expr '/' {p();} Expr {g();}
     | '-' {p();} Expr {gm();}
     | '('Expr')'
     | Expr '=' {p();} Expr {a();}
     | NUM {p();}
     | ID {p();}

%%

char stack[100][20];
int top = 0;
char cur[3] = "t0";

void p() {
    // printf("%s\n", yytext);
    strcpy(stack[top++], yytext);
}

void g() {
    // printf("%s\n", stack[top - 1]);
    printf("%s = %s % s % s\n", cur, stack[top - 3], stack[top - 2], stack[top - 1]);
    top -= 3;
    strcpy(stack[top++], cur);
    cur[1]++;
}

void gm() {
    // printf("%s\n", stack[top - 1]);
    printf("%s = %s %s\n", cur, stack[top - 2], stack[top - 1]);
    top -= 2;
    strcpy(stack[top++], cur);
    cur[1]++;
}

void a() {
    printf("%s %s %s\n", stack[top - 3], stack[top - 2], stack[top - 1]);
    top -= 3;
}

int yyerror(){
    flag = 1;
    return 1;
}

int main(int argc, char* argv[]) {
    yyin = fopen(argv[1], "r");
    yyparse();
    if (flag) printf("\nSyntactically incorrect\n");
    else printf("\nSyntactically Correct");
    return 0;
}
