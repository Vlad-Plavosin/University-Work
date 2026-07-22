%{
#include "lang.tab.h"
%}

%%

"int"       return INT;
"main"      return MAIN;
"for"       return FOR;
"if"        return IF;
"return"    return RETURN;
"print"     return PRINT;
"input"     return INPUT;
[a-zA-Z_][a-zA-Z0-9_]*  return IDENTIFIER;
[0-9]+      return NUMBER;
"("         return LPAREN;
")"         return RPAREN;
"{"         return LBRACE;
"}"         return RBRACE;
";"         return SEMICOLON;
"="         return ASSIGN;
"=="        return EQUAL;
"!="        return NOTEQUAL;
"<"         return LT;
">"         return GT;
"+"         return PLUS;
"-"         return MINUS;
"*"         return MULT;
"/"         return DIV;
"%"         return MOD;
"|"         return PIPE;
","         return COMMA;
[ \t\n]     ; // Ignore whitespace
.           { printf("Unrecognized character: %c\n", yytext[0]); }

%%

int yywrap() {
    return 1;
}