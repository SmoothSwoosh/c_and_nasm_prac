#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

typedef struct Node {
  int key, data, height;
  struct Node *left_child, *right_child;
} Node;

typedef struct Pair{
  bool flag;
  int key, data;
} Pair;

Pair make_Pair (bool flag, int key, int data) {
  Pair tmp;
  tmp.flag = flag;
  tmp.key = key;
  tmp.data = data;
  return tmp;
}

Node* new_Node (int key, int data) {
  Node* cur = (Node*)malloc(sizeof(Node));
  cur->key = key;
  cur->data = data;
  cur->left_child = cur->right_child = NULL;
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

Node* add_data (Node *cur, int key, int data) {
  if (cur == NULL) {
    return new_Node(key, data);
  }
  if (key < cur->key) {
    cur->left_child = add_data(cur->left_child, key, data);
  } else if (key > cur->key) {
    cur->right_child = add_data(cur->right_child, key, data);
  } else {
    cur->key = key;
    cur->data = data;
  }
  return balancing(cur);
}

Pair contains (Node* cur, int key) {
  if (cur == NULL) {
    return make_Pair(false, 0, 0);
  }
  if (cur->key == key) {
    return make_Pair(true, cur->key, cur->data);
  }
  if (key < cur->key)
    return contains(cur->left_child, key);
  else
    return contains(cur->right_child, key);
}

Node* avl_min (Node *cur) {
  if (cur->left_child == NULL) {
    return cur;
  }
  return avl_min(cur->left_child);
}

Node* avl_remove_min (Node *cur) {
  if (cur->left_child == NULL) {
    return cur->right_child;
  }
  cur->left_child = avl_remove_min(cur->left_child);
  return balancing(cur);
}

Node* removing (Node *cur, int key) {
  if (cur == NULL) {
    return NULL;
  }
  if (key < cur->key) {
    cur->left_child = removing(cur->left_child, key);
  } else if (key > cur->key) {
    cur->right_child = removing(cur->right_child, key);
  } else {
    Node *left = cur->left_child;
    Node *right = cur->right_child;
    free(cur);
    if (right == NULL) {
      return left;
    }
    Node *tmp = avl_min(right);
    tmp->right_child = avl_remove_min(right);
    tmp->left_child = left;
    return balancing(tmp);
  }
  return balancing(cur);
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
  char symbol;
  int key, data;
  Node *root = NULL;
  while ((symbol = getchar()) != 'F') {
    switch(symbol) {
      case 'A':
        scanf("%d%d", &key, &data);
        root = add_data(root, key, data);
        break;
      case 'D':
        scanf("%d", &key);
        root = removing(root, key);
        break;
      case 'S':
        scanf("%d", &key);
        if (contains(root, key).flag) {
          printf("%d %d\n", contains(root, key).key, contains(root, key).data);
        }
        break;
      default:
        break;
    }
  }
  destruct(root);
  return 0;
}