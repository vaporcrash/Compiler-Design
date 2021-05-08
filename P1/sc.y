%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex(void);
int yyerror();
int err_flag = 0;

// struct to represent nodes of the tree
struct Node {
    int val;
	char* id;
	char* code;
	char* line;
	char* codeO;
};
typedef struct Node Node;

int cnt_node = 1;
int cnt_label = 1;

char* get_next_tag(){
	char* ret = (char*)malloc(sizeof(char) * 10);
	sprintf(ret, "T__%d", cnt_node++);
	return ret;
}

char* get_next_label(){
	char* ret = (char*)malloc(sizeof(char) * 10);
	sprintf(ret, "L__%d", cnt_node++);
	return ret;
}

Node* get_new_node(){
	Node* ret = (Node*)malloc(sizeof(Node) * 1);
    
    ret->val = 0;
	ret->id = get_next_tag();
	ret->code = (char*)malloc(sizeof(char) * 1000);
	ret->codeO = (char*)malloc(sizeof(char) * 1000);
	ret->line = (char*)malloc(sizeof(char) * 1000);
	
    return ret;
}

// int is_tag(char *s){
//     return (s[0] == 'T') && (s[1] == '_') && (s[2] == '_');
// }

char* optimise_code(char* x, char* y, char* op, char* z, char* line){
	char* ret = (char*)malloc(sizeof(char) * 1000);
	//FOR: x=y+0; x=y*1;
	if ((strcmp(op, "+") == 0 && strcmp(z, "0") == 0) || (strcmp(op, "*") == 0 && strcmp(z, "1") == 0)){
			sprintf(ret, "%s", y);
			return ret;
		
		if (strcmp(x, y) == 0){		
		}
		sprintf(ret, "%s = %s", x, y);
	}
	//FOR: x=y-0; x=y/1;
	else if ((strcmp(op, "-") == 0 && strcmp(z, "0") == 0) || (strcmp(op, "/") == 0 && strcmp(z, "1") == 0)){
			sprintf(ret, "%s", y);
			return ret;
		if (strcmp(x, y) == 0){
		}
		sprintf(ret, "%s = %s", x, y);
	}
	//FOR: x=0+x; x=1*y
	else if ((strcmp(op, "+") == 0 && strcmp(y, "0") == 0) || (strcmp(op, "*") == 0 && strcmp(y, "1") == 0)){
			sprintf(ret, "%s", z);	
 			return ret;
		
		if (strcmp(x, z) == 0){
		}
		sprintf(ret, "%s = %s", x, z);
	}
	//FOR: x=y*2
	else if (strcmp(op, "*") == 0 && strcmp(z, "2") == 0){
		sprintf(ret, "%s = %s + %s", x, y, y);
	}
	//FOR: x=2*y
	else if (strcmp(op, "*") == 0 && strcmp(y, "2") == 0){
		sprintf(ret, "%s = %s + %s", x, z, z);
	}
	//FOR: x=pow(y,2);
	// else if (strcmp(y, 'p') == 0 && strcmp(op, 'o') == 0 && strcmp(z, 'w' )&& line[5] == '(' && line[8] == '2'){
	// 	sprintf(ret, "%s=%s*%s", x, line[6], line[6]);
	// }
	else{
		sprintf(ret, "%s", line);
	}

	return ret;
}

%}

// union defintion to access differnt yylval values
%union {
    int num;
    char chr;
    char* str;
    struct Node* node;
}

// token definitions 
%token DT IF THEN ELSE ENDIF
%token <str> ID ARITHOP RELOP LOGOP STRCONST NUMCONST
%token <chr> CHARCONST


/*
    a. left/right defines assosciativity
    b. Precedence increases down
*/

%left LOGOP
%left RELOP
%left ARITHOP
%left '!'

%type<node> Program Lines Line Assign Expr Decl

%%
Program			:	Lines		
					{
						printf("%s", $$->code);
					}
				;

Lines			: 	Line Lines 
					{
						Node* t  = get_new_node();
						sprintf(t->code, "%s\n%s", $1->code, $2->code);
						$$ = t;
					}
				| 	Line
					{
						$$ = $1;
					}
				;
				
Line			:	IF '(' Expr ')' THEN Lines ELSE Lines ENDIF
					{
						Node* t  = get_new_node();
						char *temp1 = get_next_label();
						char *temp2 = get_next_label();
						sprintf(t->code, "\tif %s goto %s \n\tgoto %s\n\n%s:%s\n%s:%s\n", $3->code, temp1, temp2, temp1, $6->code, temp2, $8->code);
						$$ = t;
					}
				|	IF '(' Expr ')' THEN Lines{}
				|	Expr';'
					{
						Node* t  = get_new_node();
						sprintf(t->code, "\t%s\n", $1->code);
						$$ = t;
					} 
				| 	Decl';'{}
				;


Expr			:	Assign {}
				|	Expr ARITHOP'=' Expr {}
				|	Expr ARITHOP Expr
					{	
						Node* lt = $1;
						Node* rt = $3;
						Node* t  = get_new_node();	

						if(strlen(lt->line) > 0){
							sprintf(t->code, "%s\n\t%s = %s %s %s", lt->code, t->id, lt->id, $2, rt->code);
							sprintf(t->line, "%s = %s %s %s", t->id, lt->id, $2, rt->code);
							sprintf(t->line, "%s", optimise_code(t->id, lt->id, $2, rt->code, t->line));
							if(strcmp(lt->id, t->line) == 0){
								sprintf(t->id, "%s", lt->id);	
								sprintf(t->code, "%s", lt->code);	
							}else if(strcmp(rt->code, t->line) == 0){
								sprintf(t->id, "%s", rt->id);	
								sprintf(t->code, "%s", rt->code);	
							}else{
								sprintf(t->code, "%s\n\t%s", lt->code, t->line);
							}
						}else{
							sprintf(t->code, "%s = %s %s %s", t->id, lt->code, $2, rt->code);
							sprintf(t->line, "%s = %s %s %s", t->id, lt->code, $2, rt->code);							
							sprintf(t->line, "%s", optimise_code(t->id, lt->code, $2, rt->code, t->line));
							
							if(strcmp(lt->code, t->line) == 0){
								sprintf(t->code, "%s", lt->code);	
								t->line[0] = '\0';	
							}else if(strcmp(rt->code, t->line) == 0){
								sprintf(t->code, "%s", rt->code);	
								t->line[0] = '\0';
							}else{
								sprintf(t->code, "%s", t->line);
							}
							
						} 
						
						$$ = t;
					} 
				|	Expr RELOP Expr{}
				|	Expr LOGOP Expr{}
				| 	ID 						
					{	
                        Node *t = get_new_node();
                        sprintf(t->code, "%s", $1);
                        $$ = t;
					}
				| 	NUMCONST
					{	
                        Node *t = get_new_node();
                        sprintf(t->code, "%s", $1);
                        $$ = t;
					}
				|	'!'Expr{}
				;


Decl			: 	DT Assign{}
				;	

Assign			:	ID'='CHARCONST  {}
				|	ID'='STRCONST{}
				|	ID'='Expr 
					{	
						Node* rt = $3;
						Node* t  = get_new_node();

						if(strlen(rt->line) > 0){
							sprintf(t->code, "%s\n\t%s = %s", rt->code, $1, rt->id);
						}else{
							sprintf(t->code, "%s = %s", $1, rt->code);
						}
						sprintf(t->line, "%s = %s", $1, rt->id);
                        
						$$ = t;
					}
				;

%%




int yyerror(){
	err_flag = 1;
	return 1;
}

int main(){
    printf("\n\t\tSYNTAX CHECKER USING YACC\n");
    /* FILE *fp;
    fp = fopen("input.txt", "r");
    if (fp) {
        yyin = fp;
    } */
    yyparse();

	// lex sc.l && yacc -dy sc.y && gcc lex.yy.c y.tab.c -o a -lm -w && ./a < input.txt
	// // lex sc.l && yacc -dy sc.y && gcc lex.yy.c y.tab.c -o a -lm  && ./a < input.txt
    return 1;
}