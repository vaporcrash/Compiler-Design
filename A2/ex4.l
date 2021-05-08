%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int i = 0;
int j = 0;
int flag = 0;
int flag1 = 0;
int addr = 1000;
char buf[100];
typedef struct 
{
    char type[100];
    char name[100];
    char value[100];
}table;
table st[100];
void func(char str[],char type[]){
    if(type=="KW"){
        if(strcmp(str,"int")==0||strcmp(str,"float")==0||strcmp(str,"char")==0){
            strcpy(buf,str);
            flag1 = 1;
        }
    }
    else if(flag1 == 0)return;
    else if(type == "ID"){
        if(flag==1){
            i++;
            strcpy(st[i].value,"--");
        }
        flag = 1;
        strcpy(st[i].name ,str);
        strcpy(st[i].type ,buf);
    }
    else if(type=="VAL"){
        strcpy(st[i].value,str);
        i++;
        flag = 0;
        strcpy(st[i].value,"--");
    }
    else if(strcmp(str,";")==0){
        if(flag==1){
            i++;
            strcpy(st[i].value,"--");
        }
        flag1 = 0;
        printf("HI\n");
    }
}
%}

assign_ops ("="|"+="|"-="|"%="|"/="|"*=")
rel_ops ("<"|">"|"<="|">="|"=="|"!=")
arith_ops ("+"|"-"|"%"|"/"|"*")
spl_chars [{}(),;\[\]]
keyword (int|float|char|unsigned|typedef|struct|return|continue|break|if|else|for|while|do|extern|auto|case|switch|enum|goto|long|double|sizeof|void|default|register)
int_const [0-9]+
float_const [0-9]+.[0-9]+
char_const [\'].[\']
string_const [\"].*[\"]
identifier [a-zA-Z_][a-zA-Z0-9_]*
function [a-zA-Z_][a-zA-Z0-9]*[(].*[)]
single_cmt [/][/].*


/*Rules*/
%%

{keyword} {
    printf("KW ");
    func(yytext,"KW");
}
{function} printf("FUNCT ");

{identifier} {
    printf("ID ");
    func(yytext,"ID");
}


{single_cmt} printf("SCMT ");

{int_const} {
    printf("INT_CONST ");
    func(yytext,"VAL");
}

{float_const} {
    printf("FLT_CONST ");
    func(yytext,"VAL");
}

{char_const} {
    printf("CHAR_CONST ");
    func(yytext,"VAL");
}

{string_const} {
    printf("STR_CONST ");
    func(yytext,"VAL");
}

{rel_ops} printf("REL_OP ");

{arith_ops} printf("ARITH_OP ");

{assign_ops} printf("ASSIGN_OP ");

{spl_chars} {
    printf("SP");
    func(yytext,"SP");
}
    


\n {
    printf("\n");
}
[ \t] { }
%%
int yywrap(void){
    return 1;
}



int main(int argc, char *argv[]){
    strcpy(st[0].value,"undefined");
    yyin = fopen(argv[1], "r");
    yylex();
    printf("TYPE\tNAME\tVALUE\tSIZE\tADDR\n");
    for(;j<i;j++){
        printf("%s\t%s\t%s\t",st[j].type,st[j].name,st[j].value);
        if(strcmp(st[j].type,"int")==0){printf("2\t");addr+=2;}
        else if(strcmp(st[j].type,"float")==0){printf("4\t");addr+=4;}
        else {printf("1\t");addr++;}
        printf("%d\n",addr);
    }
    return 0;
}