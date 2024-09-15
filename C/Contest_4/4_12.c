#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#include <string.h>
#define SYMBOLS 26

struct Node {
  struct Node **children;
  char **edgeLabel;
  bool inEnd;
};

struct Node *root;

struct Node * init_Node (bool isEnd) {
  struct Node *cur;
  cur = (struct Node *)malloc(sizeof(struct Node));
  cur->children = (struct Node **)malloc((SYMBOLS + 1) * sizeof(struct Node));
  for (int i = 0; i < SYMBOLS; ++i)
    cur->children[i] = NULL;
  cur->edgeLabel = (char **)malloc((SYMBOLS + 1) * sizeof(char *));
  for (int i = 0; i < SYMBOLS; ++i)
    cur->edgeLabel[i] = NULL;
  cur->inEnd = isEnd;
  return cur;
}

void insert_word (char *word) {
  struct Node *trav = root;
  int i = 0;
  while (i < strlen(word) && trav->edgeLabel[word[i] - 'a'] != NULL) {
    int index = word[i] - 'a';
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
        struct Node *existingChild = trav->children[index];
        struct Node *newChild = init_Node(true);
        char *remainingLabel;
        remainingLabel = (char *)malloc((strlen(label + j) + 1) * sizeof(char));
        strcpy(remainingLabel, label + j);

        label[j] = '\0';
        trav->children[index] = newChild;
        newChild->children[remainingLabel[0] - 'a'] = existingChild;
        newChild->edgeLabel[remainingLabel[0] - 'a'] = remainingLabel;
      } else {
        char *remainingLabel;
        remainingLabel = (char *)malloc((strlen(label + j) + 1) * sizeof(char));
        strcpy(remainingLabel, label + j);
        struct Node *newChild = init_Node(false);
        char *remainingWord;
        remainingWord = (char *)malloc((strlen(word + i) + 1) * sizeof(char));
        strcpy(remainingWord, word + i);
        struct Node *tmp = trav->children[index];

        label[j] = '\0';
        trav->children[index] = newChild;
        newChild->edgeLabel[remainingLabel[0] - 'a'] = remainingLabel;
        newChild->children[remainingLabel[0] - 'a'] = tmp;
        newChild->edgeLabel[remainingWord[0] - 'a'] = remainingWord;
        newChild->children[remainingWord[0] - 'a'] = init_Node(true);
      }
      return;
    }
  }
  if (i < strlen(word)) {
    trav->edgeLabel[word[i] - 'a'] = (char *)malloc((strlen(word + i) + 1) * sizeof(char));
    strcpy(trav->edgeLabel[word[i] - 'a'], word + i);
    trav->children[word[i] - 'a'] = init_Node(true);
  } else {
    trav->inEnd = true;
  }
}

long int in_trie (char *word) {
  struct Node *trav = root;
  int i = 0;

  while (i < strlen(word) && trav->edgeLabel[word[i] - 'a'] != NULL) {
    int index = word[i] - 'a';
    char *label;
    label = trav->edgeLabel[index];
    int j = 0;

    while (i < strlen(word) && j < strlen(label)) {
      if (word[i] != label[j])
        return false;
      ++i, ++j;
    }

    if (j == strlen(label) && i <= strlen(word)) {
      trav = trav->children[index];
    } else {
      return false;
    }
  }
  return (i == strlen(word) && trav->inEnd);
}

int cnt;

void print (struct Node *node) {
  for (int i = 0; i < SYMBOLS; ++i) {
    if (node->edgeLabel[i] != NULL) {
      cnt += strlen(node->edgeLabel[i]);
      print(node->children[i]);
      node->edgeLabel[i] = NULL;
      node->children[i] = NULL;
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
  cnt = 0;
  root = init_Node(false);
  char *s;
  s = (char *)malloc(2001 * sizeof(char));
  scanf("%s", s);
  for (int i = 0; i < strlen(s); ++i) {
    insert_word(s + i);
  }
  print(root);
  destruct(root);
  printf("%d", cnt + 1);
  free(s);

  return 0;
}
