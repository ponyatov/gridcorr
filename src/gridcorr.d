import std.stdio;
import std.range;

void main(string[] args) {
    arg(0, args[0]);
    foreach (argc, argv; args[1 .. $].enumerate(1)) {
        arg(argc, argv);
    }
}

void arg(size_t argc, string argv) {
    writefln("argv[%d] = <%s>", argc, argv);
}
