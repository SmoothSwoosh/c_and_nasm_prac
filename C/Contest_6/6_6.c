#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>

typedef struct Node {
  struct Node *next;
  int value;
} Node;

Node* init (void) {
  Node *cur = (Node *)malloc(sizeof(Node));
  cur->value = -1;
  cur->next = NULL;
  return cur;
}

void push (Node *root, int value) {
  Node *cur = (Node *)malloc(sizeof(char));
  while (root->next != NULL) {
    root = root->next;
  }
  root->next = cur;
  cur->value = value;
}

bool in_list (Node *root, int value) {
  while (root != NULL) {
    if (root->value == value) {
      return true;
    }
    root = root->next;
  }
  return false;
}

void output (FILE *f, Node *root_first, Node *root_second) {
  while (root_first != NULL) {
    if (!in_list(root_second, root_first->value))
    fprintf(f, "%d ", root_first->value);
    root_first = root_first->next;
  }
}

void input (FILE *f, Node *root) {
  int x = 0;
  do {
    fscanf(f, "%d", &x);
    if (x != -1) {
      push(root, x);
    }
  } while (x != -1);
}

void destruct (Node *root) {
  while (root != NULL) {
    Node *tmp = root;
    root = root->next;
    free(tmp);
  }
}

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  Node *root_first = init();
  Node *root_second = init();
  input(f_in, root_first);
  input(f_in, root_second);
  output(f_out, root_first->next, root_second);

  destruct(root_first);
  destruct(root_second);
  fclose(f_in);
  fclose(f_out);

  return 0;
}