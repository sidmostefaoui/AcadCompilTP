%option noyywrap

%{
    #include "acad.tab.h"
    #include <string.h>
    #include <stdlib.h>
    #include <limits.h>
    #include <errno.h>

    extern int nline = 1;
    extern char* token;
    int yyerror(char* error);
%}

SZ_INDEX      \[[0-9]+\]
INTEGER       -?[1-9][0-9]*
CHAR           '.'|'\\[nt0]'
STRING        \".*\"

U_REAL        [0-9]+\.[0-9]+
S_REAL        \(-[0-9]+\.[0-9]+\)
REAL          {U_REAL}|{S_REAL}
IDENTIFIER    [A-Z]([a-zA-Z]|[0-9])*
LIBRARY       PROCESS|LOOP|ARRAY
TYPE          INTEGER|REAL|CHAR|STRING         

%%

PROGRAM           { return *yytext; }
CONST             { return *yytext; }
READ|WRITE        { return *yytext; }
WHILE             { return *yytext; }
EXECUT            { return *yytext; }
IF|ELSE|ENDIF     { return *yytext; }

##                { return *yytext; }
:=                { return *yytext; }
\/\/              { return *yytext; } /* double slash */
[\{\}\[\]()]      { return *yytext; } /* {} [] () */
[\"\$#&%]         { return *yytext; } /* " $ # & % */
[+\-*\/]          { return *yytext; } /* + - * slash */
[>]

[ \t]


{LIBRARY}         { return LIBRARY; }
{TYPE}            { return TYPE;    }

{IDENTIFIER}      { 
                    if (strlen(yytext) > 10) yyerror("lexical error");
                    return IDENTIFIER;
                  }


{SZ_INDEX}        { return SZ_INDEX; }

{CHAR}            { return CHAR; }

{STRING}          { return STRING; }

{REAL}            { return REAL; }

{INTEGER}         { 
                    int val = strtol(yytext, NULL, 10);
                    if (val > 32767 || val < -32768)
                        yyerror("lexical error too big");
                    return INTEGER; 
                  }

\n                { nline++; }
.                 { yyerror("lexical error"); }

