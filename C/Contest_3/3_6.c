#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

int main(void) {
  unsigned long long n = 0;
  scanf("%llu", &n);
  char *s;
  s = (char *)malloc((n + 1) * sizeof(char));
  scanf("%s", s);
  bool flag = true;
  for (int i = 0; i < strlen(s) / 2; i++) {
    if (s[i] != s[strlen(s) - 1 - i]) {
      flag = false;
      break;
    }
  }
  if (flag)
    printf("YES");
  else
    printf("NO");
  
  free(s);

  return 0;
}