#include <stdio.h>
#include <stdbool.h>

int n;

bool check (int x) {
  int cd = 2;
  while (cd * cd <= x)
    if (x % cd == 0)
      return false;
    else
      cd++;
  return true;
}

void rec (int x, int tmp) {
  if (!check(x))
    return;
  if (check(x) && tmp == n) {
    printf("%d ", x);
    return;
  }
  rec(x * 10 + 1, tmp + 1);
  rec(x * 10 + 3, tmp + 1);
  rec(x * 10 + 7, tmp + 1);
  rec(x * 10 + 9, tmp + 1);
}

int main(void) {
  scanf("%d", &n);
  rec(2, 1);
  rec(3, 1);
  rec(5, 1);
  rec(7, 1);

  return 0;
}