#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const int BASE = 131;
const int MOD = 1e9 + 7;
 
long long h[2000002];
long long powers[2000002];

long long quick_pow(long long a, long long b) {
  long long r = 1;
  while (b) {
    if (b & 1)
      r = (r * a) % MOD;
    a = (a * a) % MOD;
    b >>= 1;
  }
  return r;
}
 
long long get_hash(int left, int right) {
  return ((h[right] - h[left - 1] + MOD) * powers[left - 1]) % MOD;
}

int main(void) {
  char *s;
  s = (char *)malloc((4000002) * sizeof(char));
  scanf("%s", s);
  char *tmp;
  tmp = (char *)malloc((2000001) * sizeof(char));
  strcpy(tmp, s);
  strcat(s, tmp);
  int n = strlen(s);
  long long p = 1;
  for (int i = 0; i < n; i++) {
    powers[i] = quick_pow(p, MOD - 2);
    p *= 131;
    p %= MOD;
  }

  p = 1;
  h[0] = 0;
  for (int i = 0; i < n; i++) {
    h[i + 1] = (h[i] + p * (s[i] - 'a')) % MOD;
    p *= 131;
    p %= MOD;
  }

  n >>= 1;
  int k = 1;
  for (int i = 2; i <= n; i++) {
    int left = 0, right = n - 1;
    while (left <= right) {
      int mid = (left + right) >> 1;
      if (get_hash(i, i + mid) == get_hash(k, k + mid))
        left = mid + 1;
      else
        right = mid - 1;
    }
    if (left <= n - 1)
      if (s[i + left - 1] < s[k + left - 1])
        k = i;
  }
  for (int i = k - 1; i < (k - 1) + n; i++)
    printf("%c", s[i]);

  free(s);
  free(tmp);
  return 0;
}