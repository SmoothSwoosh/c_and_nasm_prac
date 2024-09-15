#include <stdio.h>
#include <stdlib.h>

struct Node {
  int value, next, rear;
};

struct Node *root;
struct Node *last;
struct Node *numbers[100002];

struct Node * init_list (void) {
  struct Node *cur;
  cur = (struct Node *)malloc(sizeof(struct Node));
  last = (struct Node *)malloc(sizeof(struct Node));
  last->value = 0;
  last->rear = 0;
  last->next = 0;
  cur->value = 0;
  cur->next = 0;
  cur->rear = 0;
  return cur;
}

void destruct (int n) {
  free(root);
  free(last);
  for (int i = 0; i <= n; ++i) {
    free(numbers[i]);
  }
}

void push (int num) {
  struct Node *cur;
  cur = (last->value != 0) ? last : root;
  cur->next = num;
  numbers[num]->value = num;
  numbers[num]->next = 0;
  numbers[num]->rear = cur->value;
  last = numbers[num];
}

void swap (struct Node *a, struct Node *b) {
  numbers[a->rear]->next = b->next;
  numbers[b->next]->rear = a->rear;
  numbers[root->next]->rear = b->value;
  b->next = root->next;
  a->rear = 0;
  root->next = a->value;
}

void output (FILE *f_out) {
  struct Node *cur = numbers[root->next];
  while (cur->value != 0) {
    fprintf(f_out, "%d ", cur->value);
    cur = numbers[cur->next];
  }
}

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  int n, m, a, b;
  fscanf(f_in, "%d %d", &n, &m);

  root = init_list();
  for (int i = 0; i < n + 1; ++i) {
    numbers[i] = (struct Node *)malloc(sizeof(struct Node));
  }

  for (int x = 1; x <= n; ++x) {
    push(x);
  }

  for (int i = 0; i < m; ++i) {
    fscanf(f_in, "%d %d", &a, &b);
    if (n == 0 || numbers[a]->rear == 0) {
      continue;
    }
    swap(numbers[a], numbers[b]);
  }

  output(f_out);
  destruct(n - 1);
  fclose(f_in);
  fclose(f_out);

  return 0;
}