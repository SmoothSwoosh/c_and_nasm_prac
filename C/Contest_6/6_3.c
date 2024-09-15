#include <stdio.h>
#include <stdlib.h>
#define MAX 2000000000

struct List {
  int x, items;
  struct List *previous;
  struct List *next;
};

struct List* init (int num) {
  struct List *l;
  l = (struct List *)malloc(sizeof(struct List));
  l->x = num;
  l->next = NULL;
  l->previous = NULL;
  l->items = 1;
  return l;
}

void destruct (struct List *l) {
    struct List *tmp;
    while (l != NULL) {
        tmp = l->next;
        free(l);
        l = tmp;
    }
}


void push (struct List *l, int num) {
  while (l->next != NULL) {
    l->items++;
    l = l->next;
  }
  struct List *tmp;
  tmp = (struct List *)malloc(sizeof(struct List));
  l->next = tmp;
  l->items++;
  tmp->x = num;
  tmp->previous = l;
  tmp->next = NULL;
  tmp->items = l->items;
}

int numbers (struct List *l) {
  return l->items;
}

void output (FILE *f, struct List *l) {
  while (l != NULL) {
    fprintf(f, "%d ", l->x);
    l = l->next;
  }
  printf("\n");
}

void swap (struct List *l) {
  int temp_value = l->x;
  l->x = l->next->x;
  l->next->x = temp_value;
}

void sort (struct List *l) {
  struct List *tmp;
  tmp = (struct List *)malloc(sizeof(struct List));
  tmp = l;
  int n = l->items;
  for (int i = 0; i < n - 1; i++) {
    l = tmp;
    for (int j = 0; j < n - 1; j++) {
      if (l->x > l->next->x) {
        swap(l);
      }
      l = l->next;
    }
  }
}

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  struct List *l;
  l = (struct List *)malloc(sizeof(struct List));
  int x = 0, index = 0;
  while (fscanf(f_in, "%d", &x) == 1) {
    if (index == 0) {
      l = init(x);
      index++;
    }
    else
      push(l, x);
  }
  if (numbers(l) != 0) {
    sort(l);
    output(f_out, l);
  }
  destruct(l);
  fclose(f_in);
  fclose(f_out);

  return 0;
}