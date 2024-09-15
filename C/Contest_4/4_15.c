#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <string.h>

typedef struct Node {
  unsigned int data;
  int height;
  struct Node *left_child, *right_child;
  char *key;
} Node;

typedef struct Pair{
  bool flag;
  char *key;
  unsigned int data;
} Pair;

Pair make_Pair (bool flag, char *key, unsigned int data) {
  Pair tmp;
  tmp.flag = flag;
  tmp.key = key;
  tmp.data = data;
  return tmp;
}

Node* new_Node (char *key, unsigned int data) {
  Node* cur = (Node*)malloc(sizeof(Node));
  cur->key = key;
  cur->data = data;
  cur->left_child = NULL;
  cur->right_child = NULL;
  cur->height = 1;
  return cur;
}

int height (Node *cur) {
  if (cur == NULL) {
    return 0;
  }
  return cur->height;
}

int difference (Node *cur) {
  return height(cur->right_child) - height(cur->left_child);
}

int max (int a, int b) {
  if (a > b)
    return a;
  return b;
}

void cur_height (Node *cur) {
  int hleft = height(cur->left_child), hright = height(cur->right_child);
  cur->height = max(hleft, hright) + 1;
}

Node* Right_Rotate (Node *cur) {
  Node *tmp = cur->left_child;
  cur->left_child = tmp->right_child;
  tmp->right_child = cur;
  cur_height(cur);
  cur_height(tmp);
  return tmp;
}

Node* Left_Rotate (Node *cur) {
  Node *tmp = cur->right_child;
  cur->right_child = tmp->left_child;
  tmp->left_child = cur;
  cur_height(cur);
  cur_height(tmp);
  return tmp;
}

Node* balancing (Node *cur) {
  cur_height(cur);
  if (difference(cur) == 2) {
    if (difference(cur->right_child) < 0) {
      cur->right_child = Right_Rotate(cur->right_child);
    }
    return Left_Rotate(cur);
  } else if (difference(cur) == -2) {
    if (difference(cur->left_child) > 0) {
      cur->left_child = Left_Rotate(cur->left_child);
    }
    return Right_Rotate(cur);
  }
  return cur;
}

Node* add_data (Node *cur, char *key, unsigned int data) {
  if (cur == NULL) {
    char *tmp = (char *)malloc((strlen(key) + 1) * sizeof(char));
    strncpy(tmp, key, strlen(key));
    return new_Node(tmp, data);
  }
  if (strcmp(key, cur->key) < 0) {
    cur->left_child = add_data(cur->left_child, key, data);
  } else if (strcmp(key, cur->key) > 0) {
    cur->right_child = add_data(cur->right_child, key, data);
  } else {
    cur->key = key;
    cur->data = data;
  }
  return balancing(cur);
}

Pair contains (Node* cur, char *key) {
  if (cur == NULL) {
    return make_Pair(false, 0, 0);
  }
  if (strcmp(key, cur->key) == 0) {
    return make_Pair(true, cur->key, cur->data);
  }
  if (strcmp(key, cur->key) < 0)
    return contains(cur->left_child, key);
  else
    return contains(cur->right_child, key);
}

void destruct (Node *root) {
  if (root != NULL) {
    if (root->left_child != root->right_child) {
      destruct(root->left_child);
      destruct(root->right_child);
      root->left_child = NULL;
      root->right_child = NULL;
      free(root);
    }
  }
}

int main(void) {
  Node *root = NULL;
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  int n, m;
  unsigned int data;
  char *key = (char*)malloc(101 * sizeof(char));
  fscanf(f_in, "%d", &n);
  for (int i = 0; i < n; ++i) {
    fscanf(f_in, "%s %u\n", key, &data);
    root = add_data(root, key, data);
  }
  fscanf(f_in, "%d", &m);
  for (int i = 0; i < m; ++i) {
    fscanf(f_in, "%s", key);
    if (contains(root, key).flag) {
      fprintf(f_out, "%u\n", contains(root, key).data);
    } else {
      fprintf(f_out, "-1\n");
    }
  }
  destruct(root);
  fclose(f_in);
  fclose(f_out);
  //free(key);

  return 0;
}