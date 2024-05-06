#pragma once

#include <assert.h>
#include <stdio.h>
#include <stdlib.h>

#include <iostream>
#include <fstream>
#include <string>
using namespace std;

extern int main(int argc, char *argv[]);
extern void arg(int argc, char argv[]);

class Object {};

extern ofstream nc;

extern int yylex();
extern int yylineno;
extern char *yytext;
extern FILE *yyin;
extern void yyerror(string msg);
#include "gridcorr.parser.hpp"
