#include "gridcorr.hpp"

ofstream nc;

int main(int argc, char *argv[]) {  //
    arg(0, argv[0]);
    for (int i = 1; i < argc; i++) {  //
        arg(i, argv[i]);
        nc.open(string(argv[i]) + ".corr", ofstream::out | ostream::trunc);
        assert(yyin = fopen(argv[i], "r"));
        yyparse();
        fclose(yyin);
        nc.close();
    }
}

void arg(int argc, char argv[]) {  //
    cerr << "argv[" << argc << "] = <" << argv << ">\n";
}

void yyerror(string msg) {
    cerr << "\n\n" << yylineno << ':' << msg << '[' << yytext << "]\n\n";
    exit(-1);
}
