%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int yylex(void);
int yyerror(char *);
int flag=0;
%}


%token NUM ASSIGN ID
%token IF ELSEIF ELSE
%token FOR WHILE
%token RELOP LOGIC ARITH INDE

%%

stmts   :   bl stmts
        |   bl
        ;

bl      :   Loop '{' bl
        |   condstmt '{' bl
        |   expression ';'
        |   '}'
        ;

Loop    :   FOR '(' expression ';' condition ';' expression ')'
        |   FOR '(' ';' condition ';' ')'
        |   WHILE '(' condition ')'
        ;

condstmt :   IF '(' condition ')'
         |   ELSEIF '(' condition ')'
         |   ELSE
         ;

condition  	:   condn LOGIC condition
        	|   condn
       		;

condn       :   ID RELOP ID
	        |   ID RELOP NUM
	        |   ID
	        ;

expression    :   init
		      |   ID ASSIGN ID ARITH ID
		      |   ID ASSIGN ID ARITH NUM
		      |   ID ASSIGN NUM ARITH NUM
		      |   ID INDE
		      |   INDE ID
		      ;

init    :   ID ASSIGN init
        |   ID ASSIGN ID
        |   ID ASSIGN NUM
        ;
%%

int yyerror(char *s)
{
    flag = 1;
    return 1;
}

int main(void)
{
    printf("\n\nSYNTAX CHECKER USING YACC\n");
    printf("\nCODE\n\n");
    FILE *fp = fopen("file.txt", "r+");
    char c = fgetc(fp);
    while (c != EOF)
    {
        printf ("%c", c);
        c = fgetc(fp);
    }
    fclose(fp);
    printf("\n\n");
    FILE *fps = fopen("file.txt", "r+");
    yyparse();
    fclose(fps);
    if(flag==1)
    {
        printf("\nSyntactically Incorrect.\n");
    }

    else
    {
        printf("\nSyntactically Correct.\n");
    }

    return 0;
}
