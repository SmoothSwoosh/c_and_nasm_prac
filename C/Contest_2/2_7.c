#include <stdio.h>
#include <string.h>
#include <stdlib.h>

int used[10];
int kk = 1;

void zero_char (char* arr[10], int n) {
  for (int i = 0; i < n; i++)
    arr[i] = "";
}

void zero_int (int *arr) {
  for (int i = 0; i < 10; i++)
    arr[i] = 0;
}

void rec (char *towns[10], int k, int n, char *str) {
  if (k > kk) {
    kk = k;
  }
  for (int i = 0; i < n; i++) {
    int d2 = strlen(str);
    if (used[i] == 0 && towns[i][0] == str[d2 - 2]) {
      //printf("%c%c ", towns[i][0], str[d2 - 2]);  
      used[i] = 1;
      rec(towns, k + 1, n, towns[i]);
      used[i] = 0;
    }
  }
}

void output (char *ans[10], int len) {
  for (int i = 0; i <= len; i++)
    printf("%s", ans[i]);
  printf("\n");
}

/*int amount (int *used) {
  int ans = 0;
  for (int i = 0; i < 10; i++)
    ans += used[i];
  return ans;
}*/

int main(void) {
  int n = 0, k = 0, k_max = 0, len = 0;
  scanf("%d%*c", &n);
  if (n == 0) {
    printf("0");
    return 0;
  }
  for (int i = 0; i < n; i++)
    used[i] = 0;
  
  char *towns[n];
  for (int i = 0; i < n; i++)
    towns[i] = (char *)malloc(21 * sizeof(char));

  for (int i = 0; i < n; i++)
    fgets(towns[i], 21, stdin);

  char *ans[n];
  for (int i = 0; i < n; i++) {
    used[i] = 1;
    rec(towns, 1, n, towns[i]);
    //output();
    //k = amount(used);
    k = kk;
    kk = 1;
    //printf("%d\n", k);
    if (k == 1 && k_max == 0) {
      k_max = k;
      len = 0;
      ans[len] = towns[i];
    }
    else if (k > k_max) {
      k_max = k;
      zero_char(ans, len);
      len = 0;
      ans[len] = towns[i];
      //output(ans, len);
    } else if (k == k_max) {
      len++;
      ans[len] = towns[i];
    }
    zero_int(used);  
  }

  printf("%d\n", k_max);
  output(ans, len);
  for (int i = 0; i < n; i++)
    free(towns[i]);

  return 0;
}