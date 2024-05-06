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

mixin(grammar("
gcode:
    syntax < perc ( comment | m3 | m | ss | gnn | g | x | y | z | f )* perc eoi
    perc    <~ '%' :eol
    comment <~ '(' (!')' .)* ')' :eol
    gnn     <  (~('G' ('17'|'21'|'40'|'80'|'90'|'54')) | :ws+ | :eol )+
    m       <~ 'M' n
    m3      <~ 'M03' ws? ss :eol
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
"));
