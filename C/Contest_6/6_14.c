#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

void swap (char *a, char *b) {
  char tmp = *a;
  *a = *b;
  *b = tmp;
}

void reversing (char *arr, size_t len) {
  for (size_t i = 0; i < len / 2; ++i) {
    swap(&arr[i], &arr[len - i - 1]);
  }
}

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("matrix.in", "rb");
  f_out = fopen("trace.out", "wb");
  char *n = (char *) malloc (2 * sizeof(char));
  char *number = (char *) malloc (4 * sizeof(char));
  long long answer = 0;
  fread(n, 2 * sizeof(char), 1, f_in);
  reversing(n, 2);
  short int cursor = *(short int *)n;
  for (int i = 0; i < cursor; ++i) {
    for (int j = 0; j < cursor; ++j) {
      fread(number, 4 * sizeof(char), 1, f_in);
      reversing(number, 4);
      int cur = *(int *)number;
      if (i == j) {
        answer += (int)cur;
      }
    }
  }
  char *ans = (char *)&answer;
  reversing(ans, 8);
  fwrite(ans, 8, 1, f_out);
  fclose(f_in);
  fclose(f_out);
  free(n);
  free(number);

  return 0;
}
