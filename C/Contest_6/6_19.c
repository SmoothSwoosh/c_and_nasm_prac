#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>
#include <stdint.h>
#include <math.h>

typedef struct node {
    struct node *childs[2];
    char symbol;
    bool last;
} node;

node* init_trie (void) {
    node *root = (node *) malloc (sizeof(node));
    root->childs[0] = root->childs[1] = NULL;
    root->last = false;
    return root;
}

node* add (node *cur, int number, bool last) {
    if (cur->childs[number] != NULL) return cur->childs[number];
    node *next = (node *) malloc (sizeof(node));
    next->childs[0] = next->childs[1] = NULL;
    next->last = last;
    cur->childs[number] = next;
    return next;
}

int min (int a, int b) {
    if (a < b) return a;
    return b;
}

int main (void) {
    FILE *f_in = fopen("crypto", "r");
    FILE *f_out = fopen("text", "w");
    node *root = init_trie();
    uint8_t tmp = 0;
    int m;
    fscanf(f_in, "%c", &tmp);
    if (tmp == 0x0) m = 0x100;
    else m = tmp;
    for (int t = 0; t < m; ++t) {
        node *cur = root;
        uint8_t a, length, code, len;
        fscanf(f_in, "%c%c", &a, &length);
        len = floor(length / 8);
        if (length % 8 != 0) ++len;
        for (int i = 0; i < len; ++i) {
            fscanf(f_in, "%c", &code);
            for (int j = 0; j < min(8, length); ++j) {
                cur = add(cur, code & 1, false);
                code >>= 1;
            }
            length -= 8;
        }
        cur->symbol = a;
        cur->last = true;
    }
    node *cur = root;
    uint8_t k;
    while (fscanf(f_in, "%c", &k) == 1) {
        for (int i = 0; i < 8; ++i) {
            int index = k & 1;
            if (cur->childs[index] == NULL) exit(0);
            cur = cur->childs[index];
            if (cur->last) {
                fprintf(f_out, "%c", cur->symbol);
                cur = root;
            }
            k >>= 1;
        }
    }

    fclose(f_in);
    fclose(f_out);

    return 0;
}