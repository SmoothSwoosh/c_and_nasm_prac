#include <stdio.h>

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  int n, m, index = 0;
  fscanf(f_in, "%d%d", &n, &m);
  for (int i = 0; i < m; i++)
    fscanf(f_in, "%d", &index);
  
  for (int i = index; i <= n; i++)
    fprintf(f_out, "%d ", i);
  for (int i = 1; i < index; i++)
    fprintf(f_out, "%d ", i);

  fclose(f_in);
  fclose(f_out);

  return 0;
}