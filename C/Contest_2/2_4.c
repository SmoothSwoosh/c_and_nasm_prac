#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

bool check (char *s, int num) {
  int even = 0, odd = 0, rubikon = 0;
  for (int i = 0; i < strlen(s); i++) {
    if (i == num) {
      rubikon = 1;
      continue;
    }
    if (s[i] == 'A') {
      if (rubikon == 1) {
        if (i % 2 == 0)
          odd++;
        else
          even++;
      } else {
        if (i % 2 == 0)
          even++;
        else
          odd++;
      }
    }
  }
  if (even == odd)
    return true;
  return false;
}

int main(void)
{
  char *s;
  s = (char *) malloc(256 * sizeof(char));
  scanf("%s", s);
  for (int i = 0; i < strlen(s); i++) {
    if (check(s, i))
      printf("%d ", i + 1);
  }
  free(s);

  return 0;
}