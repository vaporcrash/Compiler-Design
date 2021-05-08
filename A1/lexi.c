#include<stdio.h>
#include<string.h>
#include<stdlib.h>
#include<ctype.h>

void lexi(char input[150]);
int check(char *input);

int main(void)
{
	int i=0;
	FILE *fp;
	char input[150];
  	fp = fopen("text.txt","r");
  	while(fgets(input,150,fp)) 
  	{
    	printf("%s\n", input);
  	}
  	fclose(fp);
  	printf("\n");
  	fp = fopen("text.txt","r");
  	while(fgets(input,150,fp)) 
  	{
    	lexi(input);
    	printf("\n");
  	}
  	fclose(fp);
}

int check(char *input)
{
	if(strcmp(input,"main")==0 || strcmp(input,"printf")==0 || strcmp(input,"scanf")==0)
	{
		return 1;
	}
	else if(strcmp(input,"char")==0 || strcmp(input,"float")==0 || strcmp(input, "int") == 0 || strcmp(input, "double") == 0 || strcmp(input, "if") == 0 || strcmp(input, "else") == 0) 
	{
		return 2;
	}
	return 0;
}


void lexi(char *input)
{
	int i=0,j=0;
	char ch,str[100];
	for(i=0;i<strlen(input);i++)
	{
		ch=input[i];
		if(ch=='=')
		{
			ch=input[++i];
			if(ch== '=')
			{
				printf("RELOP ");
			}
			else if(ch==' ')
			{
				printf("ASSIGN ");
			}
		}

		else if(ch=='<')
		{
			ch=input[++i];
			if(ch=='=')
			{
				printf("RELOP ");
			}
			else if(ch==' ')
			{
				printf("RELOP ");
			}
		}
		else if(ch=='>')
		{
			ch=input[++i];
			if(ch=='=')
			{
				printf("RELOP ");
			}
			else if(ch==' ')
			{
				printf("RELOP ");
			}
		}

		else if(ch=='&')
		{
			ch=input[++i];
			if(ch=='&')
			{
				printf("LOGICALOP ");
			}
		}
		else if(ch=='|')
		{
			ch=input[++i];
			if(ch=='|')
			{
				printf("LOGICALOP ");
			}
		}

		else if(ch=='/')
		{
			ch=input[++i];
			if(ch=='/')
			{
				printf("SINGLELINE ");
				while(i!='\n')
				{
					i++;
				}
			}
			else if(ch=='*')
			{
				printf("MULTILINE");
				while(i!='/')
				{
					i=i+1;
				}
				break;
			}
			else if(ch==' ')
			{
				printf("ARITHOP");
			}
		}

		if(ch==' ')
		{
			printf(" ");
		}

		if(ch=='{' || ch=='}' || ch==';' || ch=='(' || ch==')' || ch==',')
		{
			printf("SP ");
		}

		
		else if(ch == '+' || ch == '-' || ch == '*' || ch == '%' )
		{
			printf("ARITHOP ");
		}
		

		if(isalpha(ch)) 
    	{
    		int k;
      		while (isalnum(ch))
      		{
       	 		str[j++]=ch;
        		ch=input[++i];
      		}
     		str[j]='\0';
      		k=check(str);
      		if(k==1) 
      		{
        		printf("FC ");
        		while(i!=')')
        		{
        			i=i+1;
        		}
     		}
      		else if(k==2)
      		{
      			printf("KW ");
      		} 
      		else if(k==0) 
      		{
      			printf("ID ");
      		}
    	}

		if(isdigit(ch)==1)
		{
			printf("NUMCONST ");
		}
	}
}