#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

typedef struct Node {
  char symb;
  struct Node *next;
  struct Node *rear;
} Node;


Node* init (char symbol) {
  Node *root = (Node *)malloc(sizeof(Node));
  root->next = root;
  root->rear = root;
  root->symb = symbol;
  return root;
}

void add (Node *root, char symbol) {
  Node *cur = (Node *)malloc(sizeof(Node));
  root->rear->next = cur;
  cur->rear = root->rear;
  root->next->rear = cur;
  root->rear = cur;
  cur->next = root;
  cur->symb = symbol;
}

void output (FILE *f, Node *root, char symbol, bool flag) {
  if (!flag) {
    fprintf(f, " ");
  }
  while (root->symb != '0') {
    fprintf(f, "%c", root->symb);
    root = root->next;
  }
}

void destruct (Node *root) {
  while (root->symb != '0') {
    Node *tmp = root;
    root = root->next;
    free(tmp);
  }
}

void change (Node *root, int size) {
  int cnt = 0;
  while (cnt < size) {
    root = root->next;
    ++cnt;
  }
  root->rear->next = root->next;
  root->next->rear = root->rear;
  free(root);
}

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("words.in", "r");
  f_out = fopen("words.out", "w");
  char symbol = '0';
  bool flag = true;
  while (symbol != '.') {
    int len = 0;
    Node *root;
    root = init('0');
    if (symbol != '0') {
      add(root, symbol);
      ++len;
    }
    while ((symbol = fgetc(f_in)) != ' ') {
      if (symbol == '.') {
        break;
      }
      add(root, symbol);
      ++len;
    }
    if (len % 2 == 1 && len > 1) {
      change(root, len / 2 + 1);
    }
    if (len > 1) {
      output(f_out, root->next, symbol, flag);
      flag = false;
    }
    while (symbol == ' ') {
      symbol = fgetc(f_in);
    }
    destruct(root->next);
    free(root);
  }
  fprintf(f_out, ".");

  return 0;
}