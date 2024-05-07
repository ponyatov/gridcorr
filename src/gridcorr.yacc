%{
    #include "gridcorr.hpp"
    // #include "gridcorr.lexer.hpp"
%}

%defines %union { Object *o; char *s; char c; }

%token<c> PERC
%token<s> COMMENT Gnn F X Y Z

%%
gcode:| gcode ex

ex: PERC    { nc << $1 << endl; }
  | COMMENT { nc << $1 << endl; }
  | Gnn     { nc << $1 << endl; }
  | F       { nc << $1 << endl; }
  | X       { nc << $1 << endl; }
  | Y       { nc << $1 << endl; }
  | Z       { nc << $1 << endl; }
