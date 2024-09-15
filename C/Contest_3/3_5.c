#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void) {
  unsigned long long n = 0;
  scanf("%llu", &n);
  char *s1, *s2, *s3;
  s1 = (char *)malloc((n + 1) * sizeof(char));
  s2 = (char *)malloc((n + 1) * sizeof(char));
  s3 = (char *)malloc((n + 1) * sizeof(char));
  scanf("%s%s%s", s1, s2, s3);
  printf("%s%s%s", s3, s1, s2);

  free(s1);
  free(s2);
  free(s3);

  return 0;
}