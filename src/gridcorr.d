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
    if (p.matches.length >= 1)
        nc.writeln(p.matches[0]);
    return p;
}

ParseTree a_g(ParseTree p) @trusted {
    if (p.matches.length == 2)
        nc.write(p.matches[0], p.matches[1], ' ');
    return p;
}

ParseTree perc_(ParseTree p) @trusted {
    // if (p.matches.length > 1)
        nc.writeln(p.matches);
    return p;
}

ParseTree comment_(ParseTree p) @trusted {
    if (p.matches.length > 1)
        nc.writeln(p.matches.join);
    return p;
}

mixin(grammar("
gcode:
    syntax < ( perc | comment | m3 | m | ss | g | x | y | z | f | any )*
    perc    <~ '%' {perc_} :nl
    comment <{comment_} '(' (!')' .)* ')' :nl
    m       <~ 'M' n
    m3      <~ 'M03' ws? ss :nl
    ss      <~ 'S' n
    g       <- ~('G' n) :ws? f? :ws? x? :ws? y? :ws? z?
    x       <~ 'X' d
    y       <~ 'Y' d
    z       <~ 'Z' d
    f       <~ 'F' d
    d       <~ sn '.' n?
    sn      <~ [-+]? n
    n       <~ [0-9]+
    any     <- .
    ws      <~ [ \t]
    nl      <~ endOfLine
"));
