#include <stdio.h>
#include <stdlib.h>

struct coord {
  int x, y;
};

char *ans = "Yes";

int number;
int check;

void rec (int n, struct coord last) {
  struct coord tmp;
  if (number == (n / 2 + 1)) {
    scanf("%d%d", &tmp.x, &tmp.y);
    number++;
    check = 1;
    return;
  }
  scanf("%d%d", &tmp.x, &tmp.y);
  number++;
  last.x = tmp.x;
  last.y = tmp.y;
  rec(n, tmp); 
  scanf("%d%d", &tmp.x, &tmp.y);
  if (tmp.x != -last.x || tmp.y != last.y)
    ans = "No";
  number++;
}

int main(void) {

  int n = 0;
  struct coord coordinata;
  scanf("%d", &n);
  number = 2, check = 0;
  scanf("%d%d", &coordinata.x, &coordinata.y); 
  rec(n, coordinata);
  printf("%s", ans);
  
  return 0;
}