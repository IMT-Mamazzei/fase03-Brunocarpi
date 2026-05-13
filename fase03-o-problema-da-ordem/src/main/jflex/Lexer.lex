package br.maua.cic303;

%%

%class Lexer
%public
%unicode
%type Token
%line
%column

%{
    // Função auxiliar para gerar Tokens
    private Token token(Tag tag, String lexeme) {
        return new Token(tag, lexeme);
    }
%}

/* ========================================================================= */
/* MACROS (Expressões Regulares Auxiliares)                                  */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

/* TODO 1: Crie a macro para Número (Notação de Engenharia) */
/* Dica: Deve aceitar 7, 3.14, 6.02E23, 6.62e-34 */
Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

%%

/* TODO 2: Crie a macro para Identificador */
/* Dica: Letras, seguidas de letras, números ou _. MÁXIMO de 32 caracteres! */
/* Se a macro de max 32 for difícil, use {Letter}({Letter}|{Digit}|_)* e trate o tamanho na regra! */
Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_){0,31}

%%
/* ========================================================================= */
/* REGRAS LÉXICAS                                                            */
/* ========================================================================= */

<YYINITIAL> {
    
   /* Espaços */
    {WhiteSpace}    { /* ignora */ }

    /* ===================== PALAVRAS RESERVADAS ===================== */
    "if"            { return token(Tag.IF, yytext()); }
    "then"          { return token(Tag.THEN, yytext()); }
    "else"          { return token(Tag.ELSE, yytext()); }
    "while"         { return token(Tag.WHILE, yytext()); }

    /* ===================== PONTUAÇÃO ===================== */
    "("             { return token(Tag.LPAREN, yytext()); }
    ")"             { return token(Tag.RPAREN, yytext()); }
    "{"             { return token(Tag.LBRACE, yytext()); }
    "}"             { return token(Tag.RBRACE, yytext()); }
    ";"             { return token(Tag.SEMI, yytext()); }

    /* ===================== OPERADORES RELACIONAIS ===================== */
    "=="            { return token(Tag.REL_OP, yytext()); }
    "!="            { return token(Tag.REL_OP, yytext()); }
    "<="            { return token(Tag.REL_OP, yytext()); }
    ">="            { return token(Tag.REL_OP, yytext()); }
    "<"             { return token(Tag.REL_OP, yytext()); }
    ">"             { return token(Tag.REL_OP, yytext()); }

    /* ===================== ATRIBUIÇÃO ===================== */
    "="             { return token(Tag.ASSIGN, yytext()); }

    /* ===================== OPERADORES MATEMÁTICOS ===================== */
    "+" | "-"       { return token(Tag.ADD_OP, yytext()); }
    "*" | "/" | "%" { return token(Tag.MUL_OP, yytext()); }

    /* ===================== TOKENS ===================== */
    {Identifier}    { return token(Tag.ID, yytext()); }
    {Number}        { return token(Tag.NUMBER, yytext()); }

    /* ===================== ERROS ===================== */
    {Letter}({Letter}|{Digit}|_){32} { 
        return token(Tag.ERROR, "Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext()); 
    }

    .               { return token(Tag.ERROR, "Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

/* Regra para o Final do Arquivo */
<<EOF>>             { return token(Tag.EOF, ""); }
