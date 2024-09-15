#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#define MAXSIZE 1000001

int min (int a, int b) {
  if (a < b) {
    return a;
  }
  return b;
}

void zet_function (int *arr, char *s) {
  int length = strlen(s);
  for (int i = 1, left = 0, right = 0; i < length; ++i) {
    if (i <= right) {
      arr[i] = min(right - i + 1, arr[i - left]);
    }
    while ((i + arr[i] < length) && (s[arr[i]] == s[arr[i] + i])) {
      ++arr[i];
    }
    if ((i + arr[i] - 1) > right) {
      left = i;
      right = i + arr[i] - 1;
    }
  }
}

int compare(const void * x1, const void * x2)
{
  return ( *(int*)x1 - *(int*)x2 );
}

int main(void) {
  char *s = (char *) malloc (MAXSIZE * sizeof(char));
  scanf("%s", s);
  int len = strlen(s);
  int *z_func = (int *) malloc ((len) * sizeof(int));
  int *ans = (int *) malloc ((len) * sizeof(int));
  for (int i = 0; i < len; ++i) {
    z_func[i] = 0;
  }
  zet_function(z_func, s);
  for (int i = 0; i < len; ++i) {
    ans[i] = len - z_func[i];
    if (ans[i] > i)
        ans[i] = 0;
  }
  qsort(ans, len, sizeof(int), compare);
  int tmp = 0, k = 0;
  while (k < len) {
    if (ans[k] != tmp) {
      printf("%d ", ans[k]);
      tmp = ans[k];
    }
    ++k;
  }
  printf("%d", len);
  free(s);
  free(z_func);
  free(ans);
  return 0;
}