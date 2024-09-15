#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#define SYMBOLS 27

struct Node {
  struct Node *children[SYMBOLS];
  char *edgeLabel[SYMBOLS];
};

struct Node *root_first;
struct Node *root_second;  
struct Node *root_third;

struct Node * init_Node (void) {
  struct Node *cur;
  cur = (struct Node *)malloc(sizeof(struct Node));
  for (int i = 0; i < SYMBOLS; ++i)
    cur->children[i] = NULL;
  for (int i = 0; i < SYMBOLS; ++i)
    cur->edgeLabel[i] = NULL;
  return cur;
}

int symbol (char c) {
  if (c == '#') {
    return 0;
  }
  return 1 + c - 'a';
}

void insert_word (struct Node *root, char *word) {
  struct Node *trav = root;
  int i = 0, index = symbol(word[i]);
  while (i < strlen(word) && trav->edgeLabel[index] != NULL) {
    int j = 0;
    char *label;
    label = trav->edgeLabel[index];
    while (j < strlen(label) && i < strlen(word) && label[j] == word[i]) {
      ++i;
      ++j;
    }

    if (j == strlen(label)) {
      trav = trav->children[index];
    } else {
      if (i == strlen(word)) {
        return;
        /*struct Node *existingChild = trav->children[index];
        struct Node *newChild = init_Node();
        char *remainingLabel;
        remainingLabel = (char *)malloc((strlen(label + j) + 1) * sizeof(char));
        strcpy(remainingLabel, label + j);

        label[j] = '\0';
        trav->children[index] = newChild;
        int tmp_index = symbol(remainingLabel[0]);
        newChild->children[tmp_index] = existingChild;
        newChild->edgeLabel[tmp_index] = remainingLabel;*/
      } else {
        char *remainingLabel;
        remainingLabel = (char *)malloc((strlen(label + j) + 1) * sizeof(char));
        strcpy(remainingLabel, label + j);
        struct Node *newChild = init_Node();
        char *remainingWord;
        remainingWord = (char *)malloc((strlen(word + i) + 1) * sizeof(char));
        strcpy(remainingWord, word + i);
        struct Node *tmp = trav->children[index];

        label[j] = '\0';
        trav->children[index] = newChild;
        int tmp_index = symbol(remainingLabel[0]);
        newChild->edgeLabel[tmp_index] = remainingLabel;
        newChild->children[tmp_index] = tmp;
        tmp_index = symbol(remainingWord[0]);
        newChild->edgeLabel[tmp_index] = remainingWord;
        newChild->children[tmp_index] = init_Node();
      }
      return;
    }
    index = symbol(word[i]);
  }
  if (i < strlen(word)) {
    trav->edgeLabel[index] = (char *)malloc((strlen(word + i) + 1) * sizeof(char));
    strcpy(trav->edgeLabel[index], word + i);
    trav->children[index] = init_Node();
  }
}

void print (struct Node *node, int *cnt) {
  for (int i = 0; i < SYMBOLS; ++i) {
    if (node->edgeLabel[i] != NULL) {
      *cnt += strlen(node->edgeLabel[i]);
      print(node->children[i], cnt);
    }
  }
}

void destruct (struct Node *node) {
  if (node == NULL)
    return;
  for (int i = 0; i < SYMBOLS; ++i) {
    if (node->edgeLabel[i] != NULL) {
      destruct(node->children[i]);
      free(node->edgeLabel[i]);
    }
  }
  free(node);
}

int main(void) {
  int cnt_first = 0, cnt_second = 0, cnt_third = 0;
  root_first = init_Node();
  root_second = init_Node();
  root_third = init_Node();
  char *s_first, *s_second, *s_third;
  s_first = (char *)malloc(4001 * sizeof(char));
  s_second = (char *)malloc(4001 * sizeof(char));
  s_third = (char *)malloc(8004 * sizeof(char));
  scanf("%s", s_first);
  scanf("%s", s_second);
  int len_first = strlen(s_first) + 1, len_second = strlen(s_second) + 1;
  for (int i = 0; i < strlen(s_first); ++i) {
    insert_word(root_first, s_first + i);
  }
  print(root_first, &cnt_first);
  destruct(root_first);
  for (int i = 0; i < strlen(s_second); ++i) {
    insert_word(root_second, s_second + i);
  }
  print(root_second, &cnt_second);
  destruct(root_second);
  strcat(s_third, s_first);
  strcat(s_third, "#");
  strcat(s_third, s_second);
  for (int i = 0; i < strlen(s_third); ++i) {
    insert_word(root_third, s_third + i);
  }
  print(root_third, &cnt_third);
  destruct(root_third);
  printf("%d", cnt_first + cnt_second - (cnt_third - len_first * len_second) + 1);
  free(s_first);
  free(s_second);
  free(s_third);

  return 0;
}
