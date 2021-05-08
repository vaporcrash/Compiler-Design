%{ 
#include<stdio.h> 
#include<string.h>
#include<stdlib.h>
int i = 0;
int multiline_comment_flag = 0;

int TABLE_SIZE=0;
int TABLE_INDEX=0;

char DATATYPE[10][10];
char VARNAME[10][10];
int ADDRESS[10];
char SIZE[10][10];
char VALUES[10][10];

int id1=0; //DATATYPE
int id2=0;
int id3=0;
int id4=0;

int ADDR = 1000;

int checkExist(int idx, char *str) {
	for(int i = 0; i<idx; i++) {
		if(strcmp(VARNAME[i], str) == 0) {
			return 1;
		}
		else return 0;
	}
}

%} 

letter [a-zA-Z]
digit [0-9]
alnum [a-zA-Z0-9]+

keywords int|char|double|float|return|if|else|void

single_line_comment [/][/](.)*
num [-+]?{digit}+[.]?{digit}+
string ["](.)*["]
char [']{alnum}[']
relop <|<=|>|>=|==|!=
arithop [+*/%-]
sp [;{}()]
assign [=]
mlc_start [/][*]
mlc_end [*][/]
fc main|printf	
id {letter}+{alnum}*

/* Rules Section*/
%%
{mlc_start} {
	printf("MULTILINE COMMENT:START");
	multiline_comment_flag = 1;
}

{mlc_end} {
	printf("MULTILINE COMMENT:END")
	;multiline_comment_flag = 0;
}

{keywords} {
	if(!(multiline_comment_flag)) printf("KW ");

	if (strcmp(yytext, "int") == 0) {
		strcpy(DATATYPE[id1], "int");
		strcpy(SIZE[id1], "2");
		ADDR += 2;
		ADDRESS[id1] = ADDR;
	}
	
	else if (strcmp(yytext, "float") == 0) {
		strcpy(DATATYPE[id1], "float");
		strcpy(SIZE[id1], "4");
		ADDR += 4;
		ADDRESS[id1] = ADDR;
	}
	else if (strcmp(yytext, "char") == 0) {
		strcpy(DATATYPE[id1], "char");
		strcpy(SIZE[id1], "1");
		ADDR += 1;
		ADDRESS[id1] = ADDR;
	}
	
	id1++;
}

{fc} {
	if(!(multiline_comment_flag)) printf("FC ");
} 

{num} {
	if(!(multiline_comment_flag)) printf("NUMCONST ");
	strcpy(VALUES[id3], yytext);
	id3++;
}

{string} {
	if(!(multiline_comment_flag)) printf("SRINGCONST ");
}

{char} {
	if(!(multiline_comment_flag)) printf("CHARCONST ");
	strcpy(VALUES[id3], yytext);
	id3++;
}

{id} {
	if(!(multiline_comment_flag)) {
		printf("ID ");
		if(!checkExist(id2, yytext))
		{
			strcpy(VARNAME[id2], yytext);
			id2++;
		}
	}

}

{relop} {
	if(!(multiline_comment_flag)) printf("RELOP ");
}

{arithop} {
	if(!(multiline_comment_flag)) printf("ARITHOP ");

}

{sp} {
	if(!(multiline_comment_flag)) printf("SP ");
	if(id3 != id2) {
		strcpy(VALUES[id3], "NA");
		id3++;
	}
}

{assign} {
	if(!(multiline_comment_flag)) printf("ASSIGN ");
}

{single_line_comment} {
	if(!(multiline_comment_flag)) printf("SINGLE LINE COMMENT");
}
%% 

int yywrap(void) {} 
  
int main(int argc, char *argv[]) 
{    
	extern FILE *yyin;
	yyin = fopen(argv[1],"r");
	yylex();
	printf("\n");

	printf("\t\tSYMBOL TABLE\n\t\t============\n\n");
	for(int i=0; i<id2-1; i++) {
		printf("\t%s\t%s\t%d\t%s\t%s\n", VARNAME[i], DATATYPE[i], ADDRESS[i], SIZE[i], VALUES[i]);
	}

	printf("\n");
	return 0;
}	