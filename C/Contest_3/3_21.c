#include <stdio.h>
#include <math.h>
#include <stdbool.h>

struct pair {
  int x, y;
};

int max (int a, int b) {
  if (a > b) 
    return a;
  return b;
}

void qsortRecursive(struct pair *mas, int size) {
  int i = 0;
  int j = size - 1;

  struct pair mid = mas[size / 2];

  do {
    while(mas[i].x < mid.x || (mas[i].x == mid.x && mas[i].y < mid.y)) 
      i++;
        
    while(mas[j].x > mid.x || (mas[j].x == mid.x && mas[j].y > mid.y)) 
      j--;
      
    if (i <= j) {
      struct pair tmp = mas[i];
      mas[i] = mas[j];
      mas[j] = tmp;
      i++;
      j--;
    }
  } while (i <= j);

  if (j > 0) 
    qsortRecursive(mas, j + 1);
  if (i < size) 
    qsortRecursive(&mas[i], size - i);
}

int main(void) {
  int n = 0;
  scanf("%d", &n);
  struct pair mas[n];
  for (int i = 0; i < n; i++)
    scanf("%d%d", &mas[i].x, &mas[i].y);
  
  qsortRecursive(mas, n);

  /*for (int i = 0; i < n; i++)
    printf("%d %d\n", mas[i].x, mas[i].y);*/
  
  int last = mas[0].x, next = mas[0].y;
  for (int i = 1; i < n; i++) {
    if (last == mas[i].x) {
      if (mas[i].y > next)
        next = mas[i].y;
      continue;
    }
    if (next == mas[i].x) {
      next = mas[i].y;
      continue;
    }
    if (next > mas[i].x && next <= mas[i].y) {
      next = max(next, mas[i].y);
      continue;
    }
    if (next < mas[i].x) {
      printf("%d %d ", last, next);
      last = mas[i].x;
      next = mas[i].y;
    }
  }

  printf("%d %d ", last, next);

  return 0;
}