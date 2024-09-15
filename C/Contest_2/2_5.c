#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void move_n_chars_to_the_end (char *s, int n) {
  unsigned int length = strlen(s);
  if (n == 0)
    return;
  char *temp;
  temp = (char *) malloc((n + 1) * sizeof(char));
  strncpy(temp, s, n);
  strcpy(s, s + n);
  //printf("%s %s\n", s, temp);
  strcat(s + length - n, temp);
  //printf("%s\n", s);
  free(temp);
}

int main(void)
{
  char *s;
  unsigned int n = 0, len = 0;
  scanf("%d", &n);
  s = (char *) malloc(81 * sizeof(char));
  scanf("%s", s);
  //printf("%s", s);
  len = strlen(s);
  //printf("%d\n", len);
  move_n_chars_to_the_end(s, n % len);
  printf("%s", s);
  free(s);
  return 0;
}