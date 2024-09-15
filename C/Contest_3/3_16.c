#include <stdio.h>

#define int long long

int k;

void multiply(int a[k][k], int b[k][k], int p) {
  int res[k][k];
  for (int i = 0; i < k; i++)
    for (int j = 0; j < k; j++)
      res[i][j] = 0;
  for (int i = 0; i < k; i++) {
    for (int j = 0; j < k; j++) {
      int mul = 0;
      for (int l = 0; l < k; l++) {
        mul += (a[i][l] * b[l][j]);
        mul %= p;
      }
      res[i][j] = mul % p;
    }
  }
  for (int i = 0; i < k; i++)
    for (int j = 0; j < k; j++)
      a[i][j] = res[i][j];
}


signed main(void) {
  int n, p;
  scanf("%llu%llu%llu", &k, &n, &p);
  int matrix[k][k];
  int f[k], a[k];
  for (int i = 0; i < k; i++)
    scanf("%llu", &f[i]);
  for (int i = 0; i < k; i++)
    scanf("%llu", &a[i]);
  
  if (n <= k) {
    printf("%llu", f[n - 1] % p);
    return 0;
  }
  
  for (int i = 0; i < k; i++)
    for (int j = 0; j < k; j++)
      if (i == 0)
        matrix[i][j] = a[j];
      else if (i == j + 1)
        matrix[i][j] = 1;
      else
        matrix[i][j] = 0;
  
  int res[k][k];
  for (int i = 0; i < k; i++)
    for (int j = 0; j < k; j++)
      if (i == j)
        res[i][j] = 1;
      else
        res[i][j] = 0;

  n -= k;
  while (n) {
    if (n & 1) {
      multiply(res, matrix, p);
      n--;
    } else {
      multiply(matrix, matrix, p);
      n >>= 1;
    }
  }

  int ans = 0;
  for (int i = 0; i < k; i++) {
    ans += res[0][i] * f[k - i - 1];
    ans %= p;
  }
  
  printf("%llu", ans % p);

  return 0;
}