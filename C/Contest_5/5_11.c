#include <stdio.h>
#define int long long

int max (int a, int b) {
  if (a > b)
    return a;
  return b;
}

signed main(void) {
  int n, m;
  scanf("%llu%llu", &n, &m);
  int matr[n + 2][m + 1];
  for (int i = 1; i <= n; i++)
    for (int j = 1; j <= m; j++)
      scanf("%llu", &matr[i][j]);

  int ans[n + 2][m + 1];
  for (int i = 0; i <= n + 1; i++)
    for (int j = 0; j <= m; j++)
      ans[i][j] = 0;

  for (int j = 1; j <= m; j++) {
    for (int i = 1; i <= n; i++)
      ans[i][j] = matr[i][j] + max(max(ans[i - 1][j - 1], ans[i][j - 1]), ans[i + 1][j - 1]);
  }

  int answer = 0;
  for (int i = 0; i <= n; i++) 
    for (int j = 0; j <= m; j++)
      if (ans[i][j] > answer)
        answer = ans[i][j];
    
  printf("%llu", answer);

  return 0;
}