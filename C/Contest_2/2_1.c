#include <stdio.h>
#include <stdlib.h>
#include <string.h>

const int mod = 1791791791;
const int p = 97;

int min (int a, int b) {
  if (a < b)
    return a;
  return b;
}

long long get_hash(long long *arr, long long *pp, int i, int j) {
  return (arr[j + 1] + mod - (pp[j - i + 1] * arr[i]) % mod) % mod;
}

int main(void) {
  char *s, *s1;
  s = (char *)malloc((1e6 + 1) * sizeof(char));
  s1 = (char *)malloc((1e6 + 1) * sizeof(char));
  scanf("%s", s);
  scanf("%s", s1);
  int d = strlen(s), d1 = strlen(s1);
  long long p_pow[d];
  long long p_pow1[d1];

  p_pow[0] = 1;
  for (int i = 1; i < d; i++) {
    p_pow[i] = p_pow[i - 1] * p;
    p_pow[i] %= mod;
  }

  p_pow1[0] = 1;
  for (int i = 1; i < d1; i++) {
    p_pow1[i] = p_pow1[i - 1] * p;
    p_pow1[i] %= mod;
  }

  long long h[d + 1];
  h[0] = 0;
  for (int i = 1; i < (d + 1); i++)
    h[i] = ((h[i - 1] * p) % mod + s[i - 1] - 'a' + 1) % mod;

  long long h1[d1 + 1];
  h1[0] = 0;
  for (int i = 1; i < (d1 + 1); i++)
    h1[i] = ((h1[i - 1] * p) % mod + s1[i - 1] - 'a' + 1) % mod;

  int mx = 0;
  for (int i = 0; i < min(d, d1); i++) {
    long long hh = get_hash(h, p_pow, 0, i), h2 = get_hash(h1, p_pow1, (d1 - 1) - i, d1 - 1);
    if (hh == h2) {
      if (mx < (i + 1)) {
        mx = i + 1;
      }
    }
  }

  printf("%d ", mx);
  mx = 0;

  for (int i = 0; i < min(d, d1); i++) {
    long long hh = get_hash(h, p_pow, d - 1 - i, d - 1), h2 = get_hash(h1, p_pow1, 0, i);
    if (hh == h2) {
      if (mx < (i + 1)) {
        mx = i + 1;
      }
    }
  }
  printf("%d", mx);
  free(s);
  free(s1);

  return 0;
}