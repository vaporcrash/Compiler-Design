#include<stdio.h>
#include<stdlib.h>
#include<string.h>
int space = 0;
void indent(){
	for(int i = 0;i<space;i++)printf("   ");
}
void F(char* inp, int* cur);

void read(char* inp) {
	printf("Enter code(Expression):");
	scanf(" %[^\n]", inp);
	int n = strlen(inp);
	inp[n] = '$';
	inp[n + 1] = '\0';
}

void advance(int* cur){
	(*cur) = (*cur) + 1;
}

void err(char *inp, int *cur){
	printf("\tError:Excpected CONST token, found: %c, at column %d\n", inp[*cur], *cur);
	exit(0);
}

void Tp(char* inp, int* cur){
	space++;indent();printf("Inside Tprime\n");
	if(inp[*cur] == '*' || inp[*cur] == '/') {
		advance(cur);
		F(inp, cur);
		Tp(inp, cur);
	}
	indent();printf("Exiting Tprime\n");space--;
}

void T(char* inp, int* cur){
	space++;indent();printf("Inside T\n");
	F(inp, cur);
	Tp(inp, cur);
	indent();printf("Exiting T\n");space--;
}

void Ep(char* inp, int* cur){
	space++;indent();printf("Inside Eprime\n");
	if(inp[*cur] == '+' || inp[*cur] == '-') {
		advance(cur);
		T(inp, cur);
		Ep(inp, cur);
	}
	indent();printf("Exiting Eprime\n");space--;
}

void E(char* inp, int* cur){
	space++;indent();printf("Inside E\n");
	T(inp, cur);
	Ep(inp, cur);
	indent();printf("Exiting E\n");space--;
}

void F(char* inp, int* cur){
	space++;indent();printf("Inside F\n");
	if(inp[*cur] == '('){
		advance(cur);
		E(inp, cur);
		if(inp[*cur] == ')'){
			advance(cur);
		}else{printf("HI\n");
			err(inp, cur);
		}

	}
	else if(inp[*cur] == 'i'){
		advance(cur);
	}else{printf("HI\n");
		err(inp, cur);
	}
	indent();printf("Exiting F\n");space--;
}


void solve(char* inp, int* cur) {
	printf("\n\t Status~ \n");
	printf("     ------------------------- \n");
	E(inp, cur);
	if (inp[*cur] == '$') {
		printf("\tSUCCESS\n");
	}else{
		printf("\tFAILED\n");
	}
}


void main() {
	char* inp = (char *)malloc(sizeof(char) * 108);
	int v= 0;
	int* cur = &v;
	read(inp);
	solve(inp, cur);
}
