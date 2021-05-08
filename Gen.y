%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    int yyerror(char*);
    int yylex();
    int flag = 0;
    extern int yylineno;
    extern char* yytext;

    int curlabel = 0;
    int curtac = 0;
    int regindex = 0;

    struct node {
        char *code;
        char *varname;
        char *mcode;
    };

    typedef struct node element;

    int getreg() {
        return regindex++;
    }

    int newLabel() {
        return curlabel++;
    }

    int newTac() {
        return curtac++;
    }
    
    element *create() {
        element *n = (element*)malloc(sizeof(element));
        n->varname = (char*)malloc(10*sizeof(char));
        n->code = (char*)malloc(10000*sizeof(char));
        n->mcode = (char*)malloc(10000*sizeof(char));
        return n;
    }

    void convert(char *mc, char *lhs, char *op1, char op, char *op2) {

        char *reg1 = (char*)malloc(10*sizeof(char));
        char *l1 = (char*)malloc(10*sizeof(char));
        sprintf(reg1, "R%d", getreg());
        sprintf(l1, "MOV %s, %s", op1, reg1);
        char *reg2 = (char*)malloc(10*sizeof(char));
        char *l2 = (char*)malloc(10*sizeof(char));
        sprintf(reg2, "R%d", getreg());
        sprintf(l2, "MOV %s, %s", op2, reg2);
        char *l3 = (char*)malloc(10*sizeof(char));
        switch(op) {
            case '+':   sprintf(l3, "ADD %s, %s", reg2, reg1); break;
            case '-':   sprintf(l3, "SUB %s, %s", reg2, reg1); break;
            case '*':   sprintf(l3, "MUL %s, %s", reg2, reg1); break;
            case '/':   sprintf(l3, "DIV %s, %s", reg2, reg1); break;
        }
        char *l4 = (char*)malloc(10*sizeof(char));
        sprintf(l4, "MOV %s, %s", reg1, lhs);
        sprintf(mc, "%s\n%s\n%s\n%s\n", l1, l2, l3, l4);
    }

%}

%token BEG END IF ELSE INT CHAR FLOAT VAR CHC ID REAL EIF THEN
%token NUM RELOP AOP MOP

%right MOP
%left AOP

%union {
    char *str;
    struct node *n;
    
}

%type<str>  ID Type Value RELOP AOP MOP INT FLOAT CHAR CHC REAL NUM
%type<n> E T F Prog Decs Dec Block Con As


%%
Prog :  Decs BEG Block END {
        sprintf($$->code, "%s\n%s", $1->code, $3->code);
        sprintf($$->mcode, "%s\n%s", $1->mcode, $3->mcode);
        printf("%s\n", $$->code);
        printf("%s", $$->mcode);
    };

Decs :   Dec Decs {
        $$ = create();
        sprintf($$->code, "%s%s", $1->code, $2->code);
        sprintf($$->mcode, "%s%s", $1->mcode, $2->mcode);
    }
    |   Dec {$$ = $1;}
    ;

Dec :   VAR ID ':' Type ';' {
        $$ = create();
        sprintf($$->code, "%s:%s\n", $2, $4);
    }

    |

        VAR ID ':' Type '=' Value ';' {
        $$ = create();
        sprintf($$->code, "%s:%s = %s\n", $2, $4, $6);
        sprintf($$->mcode, "MOV %s, %s\n", $6, $2);
    }
    ;

Type :  INT {$$ = "int";} | FLOAT {$$ = "float";} | CHAR {$$ = "char";};

Value : CHC | REAL | NUM;

Block : IF '(' Con ')' THEN As ELSE As EIF {
    $$ = create();
    char *in = (char*)malloc(10*sizeof(char));
    char *out = (char*)malloc(10*sizeof(char));
    sprintf(in, "L%d", newLabel());
    sprintf(out, "L%d", newLabel());
    sprintf($$->code, "If %s Goto %s\n%s\nGoto %s\n%s\n%s\n%s\n", $3->code, in, $8->code, out, in, $6->code, out);
    sprintf($$->mcode, "If %s Goto %s\n%s\nGoto %s\n%s\n%s\n%s\n", $3->code, in, $8->mcode, out, in, $6->mcode, out);
};

Con :   ID RELOP ID {
    $$ = create();
    sprintf($$->code, "%s %s %s", $1, $2, $3);
}

    |
        
        ID RELOP NUM {
    $$ = create();
    sprintf($$->code, "%s %s %s", $1, $2, $3);
};

As : ID '=' E ';' { $$ = create(); 
sprintf($$->code, "%s\n%s = %s", $3->code, $1, $3->varname);
char *mc = (char*) malloc(500*sizeof(char));
sprintf(mc, "MOV %s, %s", $3->varname, $1);
sprintf($$->mcode, "%s\n%s", $3->mcode, mc);
 };

E : E MOP T {
    $$ = create();
    sprintf($$->varname, "t%d", newTac());
    sprintf($$->code, "%s%s\n%s = %s %s %s\n", $1->code, $3->code, $$->varname, $1->varname, $2, $3->varname);
    char *mc = (char*) malloc(500*sizeof(char));
    convert(mc, $$->varname, $1->varname, $2[0], $3->varname);
    sprintf($$->mcode, "%s%s\n%s", $1->mcode, $3->mcode, mc);
};

E : T {
    $$ = $1;
};

T : T AOP F {
    $$ = create();
    sprintf($$->varname, "t%d", newTac());
    sprintf($$->code, "%s%s\n%s = %s %s %s\n", $1->code, $3->code, $$->varname, $1->varname, $2, $3->varname);
    char *mc = (char*) malloc(500*sizeof(char));
    convert(mc, $$->varname, $1->varname, $2[0], $3->varname);
    sprintf($$->mcode, "%s%s\n%s", $1->mcode, $3->mcode, mc);
};

T : F {
    $$ = $1;
};

F : ID {
    $$ = create();
    strcpy($$->varname, $1);
};

%%

int yyerror(char *s)
{
    flag = 1;
    return 1;
}

int main()
{
    yyparse();
    return 0;
}