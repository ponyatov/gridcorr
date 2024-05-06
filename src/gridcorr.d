import std.stdio;
import std.range;
import std.file;

void main(string[] args) {
    arg(0, args[0]);
    foreach (argc, argv; args[1 .. $].enumerate(1)) {
        arg(argc, argv);
        auto nc = File(argv ~ ".corr", "w");
        nc.writeln(gcode(readText(argv)));
        nc.close();
    }
}

void arg(size_t argc, string argv) {
    writefln("argv[%d] = <%s>", argc, argv);
}

import pegged.grammar;

mixin(grammar("
gcode:
    syntax < (perc | comment | any)*
    perc < '%'
    comment <~'(' .*? ')'
    any  < .
"));
