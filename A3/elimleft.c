#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

int main() {
	char* name = (char*)calloc(100,sizeof(char));
	printf("Enter File name: ");
	scanf("%[^\n]",name);
	FILE *fp;
	fp = fopen(name, "r");
	int i = 0;
	char str[100];
	char ans[100][100];
    int arow = 0,acol = 0;
    printf("\n\t Eliminate left recursion\n");
	int flag = 0;
	while(fgets(str, 100, fp)) {
		str[strlen(str)] = '\0';
		char ch = str[0];
		int start = 3;
		int p1 = 0;
		int p2 = 0;
		char beta[100][100];
		char alpha[100][100];
		char A = str[0];
		for(int i=3;i<=strlen(str);i++){
			if(str[i] == '|'||str[i]=='\0'){
				int h = 0;
				if(str[start]==A){
					for(int j=start+1;j<i;j++){
						alpha[p1][h] = str[j];
						h++;
					}
					alpha[p1][h] = '\0';
					p1++;
				}
				else{
					for(int j=start;j<i;j++){
						if(str[i]=='\0'&&j==i-1)
							break;
						beta[p2][h] = str[j];
						h++;
					}
					beta[p2][h] = '\0';
					p2++;
				}
				start = i+1;
			}
		}

		if(p1==0){
			strcpy(ans[arow],str);
			arow++;
			continue;
		}
		flag = 1;
		ans[arow][0] = A;
		ans[arow][1] = '-';
		ans[arow][2] = '>';
		acol = 3;

		for(int i=0;i<p2;i++){
			for(int j=0;beta[i][j]!='\0';j++){
				ans[arow][acol] = beta[i][j];
				acol++;
			}
			ans[arow][acol] = A;
			acol++;
			ans[arow][acol] = '\'';
			acol++;
			if(i!=p2-1){
				ans[arow][acol] = '|';
				acol++;
			}
		}
		ans[arow][acol] = '\0';

		arow++;
		acol = 6;
		ans[arow][0] = A;
		ans[arow][1] = '\'';
		ans[arow][2] = '-';
		ans[arow][3] = '>';
		ans[arow][4] = 'e';
		ans[arow][5] = '|';
		for(int i=0;i<p1;i++){
			for(int j=0;alpha[i][j]!='\0';j++){
				ans[arow][acol] = alpha[i][j];
				acol++;
			}
			ans[arow][acol] = A;
			acol++;
			ans[arow][acol] = '\'';
			acol++;
			if(i!=p1-1){
				ans[arow][acol] = '|';
				acol++;
			}
		}
		ans[arow][acol] = '\0';
		arow++;
    }
   	if(!flag){
   		printf("No left recursion\n");
   	}
   	printf("New grammar:\n");

   	for(int i=0;i<arow;i++){
		printf("%s\n",ans[i]);
	}
}
