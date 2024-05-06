import std.stdio;
import std.range;
import std.file;

File nc; /// output .nc

void main(string[] args) {
    arg(0, args[0]);
    foreach (argc, argv; args[1 .. $].enumerate(1)) {
        arg(argc, argv);
        nc = File(argv ~ ".corr", "w");
        nc.writeln(gcode(readText(argv)));
        nc.close();
    }
}

void arg(size_t argc, string argv) {
    writefln("argv[%d] = <%s>", argc, argv);
}

import pegged.grammar;

ParseTree a_nl(ParseTree p) @trusted {
    nc.write("\n");
    return p;
}

ParseTree a_g(ParseTree p) @trusted {
    if (p.matches.length>1)
        nc.writef("%s\n",p.children);
    return p;
}

mixin(grammar("
gcode:
    syntax < ( nl | ws | perc | comment | m | ss | g | x | y | z | f | any )*
    nl      <~ [\r\n]+ {a_nl}
    perc    <~ '%'
    comment <~ '(' (!')' .)* ')'
    m       <~ 'M' n
    ss      <~ 'S' n
    g       <~ ( 'G' n ) {a_g}
    x       <~ 'X' d
    y       <~ 'Y' d
    z       <~ 'Z' d
    f       <~ 'F' d
    d       <~ sn '.' n?
    sn      <~ [-+]? n
    n       <~ [0-9]+
    ws      <  [ \t\r\n\f]+
    any     < .
"));
