%{
/*
NISARG P. GOGATE
BT18CSE040
*/
#include<stdio.h>
#include<string.h>
#include<stdlib.h>

// declarations
void insert(int subtype);
void yyerror(const char *str);
int yylex(void);
void isValid();
void print();

int err_no = 0, fl = 0, i = 0, j = 0, type[100];
int  level = 0, count[10];    // count stores the number of vars in each level

char symbol_table[10][100][100], temp[100];   // symbol table can store upto 10 levels and variable names
int current_sublevel[10],sublevel[10][100];   // For implementation of sublevels 2a,2b...
%}

%union {
    int iValue; /* integer value */
    char* sIndex; /* symbol_table[level] table index */
};  
%token <sIndex> OPEN_PARA CLOSE_PARA OPEN_BRA CLOSE_BRA MAIN WHILE EXIT;
%token <sIndex> ID;
%token <iValue> SE;
%token <iValue> C;
%token <iValue> INT;
%token <iValue> FLOAT; 
%token <iValue> CHAR ;
%token <iValue> DOUBLE;
%%
START:START S1 '\n'
    |
    ;
S1:S1 S
    | S
    ;
S:    INT L1 E
    | FLOAT L2 E
    | CHAR L3 E
    | DOUBLE L4 E
    | MAIN OPEN_BRA CLOSE_BRA OPEN_PARA {level++;}
    | WHILE OPEN_BRA CLOSE_BRA OPEN_PARA {level++;}
    | CLOSE_PARA {isValid();level--;}
    | EXIT {printf("EXITING...\n\n");print();exit(EXIT_SUCCESS);}
    ;
L1:L1 C ID{strcpy(temp,(char *)$3); insert(0);}
    | ID {strcpy(temp,(char *)$1); insert(0);}
    ;
L2:L2 C ID{strcpy(temp,(char *)$3); insert(1);}
    | ID {strcpy(temp,(char *)$1); insert(1);}
    ;
L3:L3 C ID{strcpy(temp,(char *)$3); insert(2);}
    | ID {strcpy(temp,(char *)$1); insert(2);}
    ;
L4:L4 C ID{strcpy(temp,(char *)$3); insert(3);}
    | ID {strcpy(temp,(char *)$1); insert(3);}
    ;
E:SE
;
%%
// Returns syntax errors
void yyerror(const char *str) {printf("error\n");}
// End
int yywrap(){return 1;}

int main()
{
    yyparse();
    return 0;
}
// subtype tells type of variable 0-int 1-float 2-char 3-double
void insert(int subtype)
{
    fl = 0;
    for(j = 0; j < count[level]; j++)
    {
        // if the sublevel of current varible is same as that of the sublevel of iterator
        // and the varible name matches
        if(sublevel[level][j] == current_sublevel[level] && strcmp(temp, symbol_table[level][j]) == 0)
        {
            if(type[i] == subtype)
                printf("Redeclaration of variable\n");
            else 
            {
                printf("Multiple Declaration of Variable\n");err_no=1;
            }
            fl = 1;
        }
    }
    if(fl == 0)
    {
        type[count[level]] = subtype;
        strcpy(symbol_table[level][count[level]], temp);
        sublevel[level][count[level]] = current_sublevel[level];
        count[level]++;
    }
}
// Checks if number of '}' is less than or equal to '{'
void isValid()
{
    if(level < 0)
    {
        printf("INVALID SYNTAX\n");
        exit(0);
    }
    current_sublevel[level]++;           //Will increment the count of {} at same level i.e, A/B/C..
}

void print()
{
    printf("------------Printing Symbol table-------------\n");
    if(err_no == 0)
    {
        for(int l = 0; l < 10; l++)
        {
            for(j = 0; j < count[l]; j++)
            {
                if(type[j] == 0)
                    printf("INT - ");
                else if(type[j] == 1)
                    printf("FLOAT - ");
                else if(type[j] == 2)
                    printf("CHAR - ");
                else if(type[j] == 3)
                    printf("DOUBLE - ");
                printf("%s   Level : %d%c\n", symbol_table[l][j], l, 'a' + (char)sublevel[l][j]);
            }
        }
    }
}