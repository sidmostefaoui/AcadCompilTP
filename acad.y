
%{
    #include <stdio.h>
    #include <stdbool.h>
    int yyerror(char* error);
    extern FILE* yyin;
    extern int nline;
    extern char* yytext;
%}

%token LIBRARY R_PROGRAM

%token TYPE CONST 

%token IDENTIFIER SZ_INDEX

%token INTEGER CHAR STRING REAL

%left '+' '-'
%left '*' '/'


%%


program:
            lib main
            ;

lib:
            '##' LIBRARY lib { printf("lib parsed\n"); } 
            |
            ;


main:
            'PROGRAM' IDENTIFIER '{' body '}'
            ;


body:
            declarations instructions
            ;


declarations: 
            declarations declaration '$'
            | 
            ;

declaration:
             var
            | const
            ;

var:        TYPE IDENTIFIER more { printf("var parsed\n"); }
            | TYPE IDENTIFIER SZ_INDEX more { printf("array parsed\n"); }
            ;

const:      'CONST' IDENTIFIER more { printf("const parsed\n"); }
            | 'CONST' IDENTIFIER SZ_INDEX more
            ;

more:       '//' IDENTIFIER more
            | '//' IDENTIFIER SZ_INDEX more
            |
            ;

instructions:
                instructions instruction '$'
                |
                ;

instruction:
                IDENTIFIER ':=' expr
                ;

expr:
                INTEGER
                | REAL  
                | STRING
                | CHAR
                | IDENTIFIER
                | expr '+' expr
                | expr '-' expr
                | expr '*' expr
                | expr '/' expr
                | '(' expr ')'
                ;

%%

int yyerror(char* error) {
    printf("%s: line %i: %s \n", error, nline, yytext);
    return 1;
}

int main (int argc, char* argv[]) {

    if (argc > 1){
        yyin = fopen(argv[1], "r");
        yyparse();
        fclose(yyin);
    } else {
        while(true) {
            printf(">>> ");
            yyparse();
        }
    }
    
    return 0;
}

