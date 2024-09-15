#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int main(void) {
  char *str;
  str = (char *) malloc(101 * sizeof(char));
  scanf("%s", str);
  int mas[1000];
  for (int i = 0; i < 1000; i++)
    mas[i] = 0;

  int cnt = 0;
  for (int i = 0; i < strlen(str) - 2; i++) {
    for (int j =  i + 1; j < strlen(str) - 1; j++) {
      for (int k = j + 1; k < strlen(str); k++) {
        int a1, a2, a3;
        a1 = 100 * (str[i] - '0');
        a2 = 10 * (str[j] - '0');
        a3 = str[k] - '0';
        if ((a1 + a2 + a3) < 100) 
          continue;
        if (mas[a1 + a2 + a3] == 0) {
          mas[a1 + a2 + a3] = 1;
          cnt++;
        }
      }
    }
  }

  printf("%d", cnt);
  free(str);

  return 0;
}