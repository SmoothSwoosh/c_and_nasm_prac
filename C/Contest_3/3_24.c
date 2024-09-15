#include <stdio.h>
#include <stdbool.h>
#include <math.h>

#define int long long

int min(int a, int b) {
  if (a < b)
    return a;
  return b;
}

int lighten (int n) {
  int last = 0, last_positive = 0, x = 0, ans = 0;
  bool flag = true;
  for (int i = 1; i <= n; i++) {
    scanf("%llu", &x);
    if (x == 0)
      continue;
    if (x < 0) {
      ans += min(last_positive - x, i - last - 1);
      if (i + x <= last && last != 0 && flag) 
        ans++;
      if (last_positive + last >= i && last != 0) {
        ans++;
        flag = false;
      } else {
        flag = true;
      }
      last_positive = 0;
      last = i;
    } else if (x > 0) {
      ans += min(last_positive, i - last - 1);
      if (last_positive + last >= i && last != 0) {
        ans++;
        flag = false;
      } else {
        flag = true;
      }
      last_positive = x;
      last = i;
    }
    //printf("%llu\n", ans);
  }
  if (last_positive > 0) 
    ans += min(n - last, last_positive);
  
  return ans;
}

signed main(void) {
  int n = 0;
  scanf("%llu", &n);
  
  printf("%llu", lighten(n));

  return 0;
}
