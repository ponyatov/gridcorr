%{
    #include "gridcorr.hpp"
    // #include "gridcorr.lexer.hpp"
%}

%option yylineno noyywrap


n [0-9]+
d {n}.([0-9]*)?
%%
%          { yylval.c = yytext[0]; return PERC; }
\([^\)]*\) { yylval.s = yytext; return COMMENT; }
G{n}       { yylval.s = yytext; return Gnn; }
F{d}       { yylval.s = yytext; return F; }
X{d}       { yylval.s = yytext; return X; }
Y{d}       { yylval.s = yytext; return Y; }
Z{d}       { yylval.s = yytext; return Z; }
[ \t\r\n]+ {}
.          { yyerror(yytext); }
