#include "gridcorr.hpp"

int main(int argc, char *argv[]) { //
  arg(0, argv[0]);
  for (int i = 1; i < argc; i++) { //
    arg(i, argv[i]);
  }
}

void arg(int argc, char argv[]) { //
  printf("argv[%i] = <%s>\n", argc, argv);
}
