%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "lang.tab.h"

void print_token(int token) {
    switch (token) {
        case INT: printf("INT\n"); break;
        case MAIN: printf("MAIN\n"); break;
        case FOR: printf("FOR\n"); break;
        case IF: printf("IF\n"); break;
        case RETURN: printf("RETURN\n"); break;
        case PRINT: printf("PRINT\n"); break;
        case INPUT: printf("INPUT\n"); break;
        case IDENTIFIER: printf("IDENTIFIER\n"); break;
        case NUMBER: printf("NUMBER\n"); break;
        case LPAREN: printf("LPAREN\n"); break;
        case RPAREN: printf("RPAREN\n"); break;
        case LBRACE: printf("LBRACE\n"); break;
        case RBRACE: printf("RBRACE\n"); break;
        case SEMICOLON: printf("SEMICOLON\n"); break;
        case ASSIGN: printf("ASSIGN\n"); break;
        case EQUAL: printf("EQUAL\n"); break;
        case NOTEQUAL: printf("NOTEQUAL\n"); break;
        case LT: printf("LT\n"); break;
        case GT: printf("GT\n"); break;
        case PLUS: printf("PLUS\n"); break;
        case MINUS: printf("MINUS\n"); break;
        case MULT: printf("MULT\n"); break;
        case DIV: printf("DIV\n"); break;
        case MOD: printf("MOD\n"); break;
        case PIPE: printf("PIPE\n"); break;
        case COMMA: printf("COMMA\n"); break;
        default: printf("UNKNOWN TOKEN\n"); break;
    }
}

int yyerror(const char* s);
%}

%token INT MAIN FOR IF RETURN PRINT INPUT IDENTIFIER NUMBER
%token LPAREN RPAREN LBRACE RBRACE SEMICOLON ASSIGN EQUAL NOTEQUAL LT GT PLUS MINUS MULT DIV MOD PIPE COMMA

%%

program:
    INT MAIN LPAREN RPAREN LBRACE statements RBRACE {
        print_token(INT);
        print_token(MAIN);
        print_token(LPAREN);
        print_token(RPAREN);
        print_token(LBRACE);
        print_token(RBRACE);
    }
    ;

statements:
    | statements statement
    ;

statement:
      IDENTIFIER ASSIGN INPUT PIPE SEMICOLON {
        print_token(IDENTIFIER);
        print_token(ASSIGN);
        print_token(INPUT);
        print_token(PIPE);
        print_token(SEMICOLON);
    }
    | FOR LPAREN IDENTIFIER COMMA expr RPAREN LBRACE statements RBRACE {
        print_token(FOR);
        print_token(LPAREN);
        print_token(IDENTIFIER);
        print_token(COMMA);
        print_token(RPAREN);
        print_token(LBRACE);
        print_token(RBRACE);
    }
    | IF LPAREN expr RPAREN LBRACE statements RBRACE {
        print_token(IF);
        print_token(LPAREN);
        print_token(RPAREN);
        print_token(LBRACE);
        print_token(RBRACE);
    }
    | PRINT LPAREN IDENTIFIER RPAREN PIPE SEMICOLON {
        print_token(PRINT);
        print_token(LPAREN);
        print_token(IDENTIFIER);
        print_token(RPAREN);
        print_token(PIPE);
        print_token(SEMICOLON);
    }
    | RETURN PIPE SEMICOLON {
        print_token(RETURN);
        print_token(PIPE);
        print_token(SEMICOLON);
    }
    ;

expr:
      expr PLUS expr {
        print_token(PLUS);
    }
    | expr MINUS expr {
        print_token(MINUS);
    }
    | expr MULT expr {
        print_token(MULT);
    }
    | expr DIV expr {
        print_token(DIV);
    }
    | expr MOD expr {
        print_token(MOD);
    }
    | NUMBER {
        print_token(NUMBER);
    }
    | IDENTIFIER {
        print_token(IDENTIFIER);
    }
    ;

%%

int yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
    return 0;
}

int main(int argc, char** argv) {
    if (yyparse() == 0) {
        printf("Parsing successful!\n");
    }
    return 0;
}
