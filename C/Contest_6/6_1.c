#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  bool prev = false, check = false;
  long long W = 0, S = 0, P = 0;
  char c = fgetc(f_in);
  while (c == '\n' || c == ' ') {
    c = fgetc(f_in);
  }
  prev = true;
  while (c != EOF) {
    if (!prev) {
      c = fgetc(f_in);
    }
    if (!(c == '\n' || c == ' ' || c == '.' || c == '-')) {
      check = true;
    }
    switch (c) {
      case '.':
        while ((c = fgetc(f_in)) == ' ') {
          continue;
        }
        int cnt = 0;
        if (c == '\n') {
          ++cnt;
        }
        while (c == '\n' || c == ' ') {
          c = fgetc(f_in);
          if (c == '\n') {
            ++cnt;
          }
        }
        if (cnt > 1 || c == EOF) {
          ++P;
        }
        prev = true;
        if (check) {
          ++W;
        }
        ++S;
        break;
      case '-':
        c = fgetc(f_in);
        while (c == ' ' || c == '\n') {
          c = fgetc(f_in);
        }
        prev = true;
        break;
      case ' ':
        if (check) {
          ++W;
        }
        c = fgetc(f_in);
        while (c == ' ' || c == '\n') {
          c = fgetc(f_in);
          continue;
        }
        prev = true;
        break;
      case '\n':
        if (check) {
          ++W;
        }
        break;
      default:
        prev = false;
        break;
    }
  }

  fprintf(f_out, "%lld %lld %lld", W, S, P);
  fclose(f_in);
  fclose(f_out);

  return 0;
}