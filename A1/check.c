// Lexical analyser - scans code and recognizes tokens

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>



int is_keyword(char *token)
{
    int i;

    char keywords[][32] = {"int", "char", "float",
    "if", "else", "for", "do", "while", "break", "continue", "switch", "case", "return", "short", "long", "double", "const", "struct", "sizeof",  "typedef", "signed", "unsigned", "extern", "enum", "union", "void", "static",  "default", "goto", "register", "volatile", "auto"};

    for (i = 0; i < 32; ++i)
    {
        if (strcmp(token, keywords[i]) == 0)
            return 1;
    }

    return 0;
}

int is_identifier(char *token)
{
    int len = strlen(token);
    int i;

    // Identifiers start with a letter/underscore
    if (!isalpha(token[0]) && token[0] != '_')
    {
        return 0;
    }

    // Followed by letter/digit/underscore
    for (i = 1; i < len; ++i)
    {
        if (!isalnum(token[i]) && token[i] != '_')
        {
            return 0;
        }
    }

    return 1;
}

// Returns 1 if token is a number constant
// Returns 2 if token is a character constant
// Returns 3 if token is a string constant
// Returns 0 if token is not a constant

int is_constant(char *token)
{
    int i = 0;
    int constant = -1;
    int len = strlen(token);
    int decimal_pt = 0;

    // STRCONST
    if (token[0] == '"' && token[len - 1] == '"')
        return 3;

    // CHARCONST
    if (token[0] == '\'' && token[len - 1] == '\'' && len == 3)
        return 2;

    // NUMCONST
    for (i = 0; i < len && decimal_pt < 2; ++i)
    {

        if (token[i] == '.')
        {
            decimal_pt++;
            continue;
        }

        if (!isdigit(token[i]))
        {
            return 0;
        }
    }

    return 1;
}
char* parse(char *str)
{
    int i, len = strlen(str), j = 0;
    char *str1 = (char*)malloc(sizeof(char)*64);

    // for (i = 0; i < n; ++i)
    // for:(:i:=:0:;:i:<:n:;:++:i:)
    // printf("%s", str);
    // printf:(:"%s":,::str:):;:
    int flag = 0;

    for (i = 0; i < len; ++i)
    {

        if((str[i] == '+' && str[i + 1] == '+') || (str[i] == '-' && str[i + 1] == '-') || str[i] == '.')
            continue;

        if ((flag == 0 && str[i] == '"'))
        {
            if (j > 0 && str1[j - 1] != ':')
            {
                str1[j++] = ':';
            }
            str1[j++] = str[i];
            flag = 1;
            continue;
        }

        if (flag)
        {
            str1[j++] = str[i];
            if (str[i] == '"')
            {
                str1[j++] = ':';
                flag = 0;
            }
            continue;
        }


        if (isspace(str[i]))
        {
            str1[j++] = ':';
        }
        else if (!isalnum(str[i]))
        {
            if (j > 0 && str1[j - 1] != ':')
            {
                str1[j++] = ':';
            }
            str1[j++] = str[i];
            str1[j++] = ':';
        }
        else
            str1[j++] = str[i];
    }

    return str1;
}

void scan_line(char *str)
{
    char *token = (char*)malloc(sizeof(char) * 64);
    char *line = str;
    int c, id = 0;

    char *analysed = (char*)malloc(sizeof(char) * 64);
    strcat(analysed, "");

    while ((token = strtok_r(line, ":", &line)))
    {
        //printf("\nToken: %s \n", token);
        int len = strlen(token);

        if(is_keyword(token))
        {
            strcat(analysed, "KW ");
        }
        else if (is_identifier(token))
        {
            id = 1;
            strcat(analysed, "ID ");
        }
        else if (strcmp(token,"=") == 0)
        {
            strcat(analysed, "ASSIGN ");
        }
        else if ((c = is_constant(token)))
        {
            if (c == 1)
                strcat(analysed, "NUMCONST ");
            else if (c == 2)
                strcat(analysed, "CHARCONST ");
            else if (c == 3)
                strcat(analysed, "STRCONST ");
        }
        else if (strcmp(token,"==") == 0 || strcmp(token,">=") == 0 || strcmp(token,"<=") == 0 || strcmp(token,">") == 0 || strcmp(token,"<") == 0)
        {
            strcat(analysed, "RELOP ");
        }
        else if (token[0] == '!' || strcmp(token,"&&") == 0 || strcmp(token,"||") == 0)
        {
            strcat(analysed, "LOGOP ");
        }
        else if ((strcmp(token,"++") == 0 || strcmp(token,"--") == 0 ) || (len == 1 && (token[0] == '+' || token[0] == '-' || (id == 1 && token[0] == '*') || token[0] == '/')))
        {
            strcat(analysed, "ALOP ");
            //id = 0;
        }
        else if (id == 1 && token[0] == '(') // Function call
        {
            int len = strlen(analysed);
            analysed[len - 3] = 'F';
            analysed[len - 2] = 'C';
            analysed[len - 1] = '\0';
            strcat(analysed, " SP ");
            //id = 0;
        }
        else if (ispunct(token[0]) || (id == 0 && token[0] == '*'))
        {
            strcat(analysed, "SP ");
        }

    }
    strcat(analysed, "\n");
    printf("%s ", analysed);
    return ;
}
int main(void)
{
    char *str = (char*)malloc(sizeof(char));
    /*printf("Enter line: ");
    scanf(" %[^\n]s", str);
    str = parse(str);
    scan_line(str);*/

    FILE *fp;
    size_t len = 0;
    size_t read = 0;

    fp = fopen("../sample.txt", "r");
    if (fp == NULL)
    {
        printf("NO");
        exit(EXIT_FAILURE);

    }


    while((read = getline(&str, &len, fp)) != -1)
    {
        str = parse(str);
        scan_line(str);
    }

    fclose(fp);

    return 0;
}
