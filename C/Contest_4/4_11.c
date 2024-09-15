#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>
#define MAXSIZE 100000

typedef struct Stack_symbol {
    char arr[MAXSIZE * 10];
    int last;
} Stack_symbol;

Stack_symbol* init_symbol (void) {
    Stack_symbol *head = (Stack_symbol *) malloc (sizeof(Stack_symbol));
    head->last = -1;
    return head;
}

void add_symbol (Stack_symbol *cur, char c) {
    cur->arr[++cur->last] = c;
}

char pop_symbol (Stack_symbol *cur) {
    char ans = cur->arr[cur->last--];
    return ans;
}

char peek_symbol (Stack_symbol *cur) {
    return cur->arr[cur->last];
}

typedef struct Stack {
    long long int arr[MAXSIZE];
    int last;
} Stack;

Stack* init (void) {
    Stack *head = (Stack *) malloc (sizeof(Stack));
    head->last = -1;
    return head;
}

void add (Stack *cur, long long int number) {
    cur->arr[++cur->last] = number;
}

long long int pop (Stack *cur) {
    long long int ans = cur->arr[cur->last--];
    return ans;
}

bool number (char c) {
    return c - '0' >= 0 && c - '0' <= 9;
}

bool sign (char c) {
    return c == '+' || c == '-' || c == '*' || c == '/';
}

void convert_to_polish_notation (FILE *f_in, FILE *f_out) {
    Stack_symbol *cur = init_symbol();
    char c = ' ';
    bool flag = false;
    while (c != EOF) {
        if (!flag) c = fgetc(f_in);
        if (c == ' ') continue;
        if (number(c)) {
            char s_tmp[11];
            int tmp = c - '0';
            flag = true;
            while (number(c = fgetc(f_in))) {
                tmp *= 10;
                tmp += c - '0';
            }
            sprintf(s_tmp, "%d", tmp);
            fprintf(f_out, "%s ", s_tmp);
            if (c == ' ') flag = false;
            continue;
        } else if (c == '-') {
            while (cur->last != -1) {
                char symbol = peek_symbol(cur);
                if (!sign(symbol)) break;
                pop_symbol(cur);
                fprintf(f_out, "%c ", symbol);
            }
            add_symbol(cur, c);
            while ((c = fgetc(f_in)) == ' ') continue;
            flag = true;
            if (c == '-') {
                char s_tmp[11];
                int tmp = 0;
                while (number(c = fgetc(f_in))) {
                    tmp *= 10;
                    tmp += c - '0';
                }
                sprintf(s_tmp, "%d", -tmp);
                fprintf(f_out, "%s ", s_tmp);
            } else if (number(c)) {
                char s_tmp[11];
                int tmp = c - '0';
                while (number(c = fgetc(f_in))) {
                    tmp *= 10;
                    tmp += c - '0';
                }
                sprintf(s_tmp, "%d", tmp);
                fprintf(f_out, "%s ", s_tmp);
            }
            if (c == ' ') flag = false;
            continue;
        } else {
            switch (c) {
                case '(': {
                    add_symbol(cur, c);
                    break;
                }
                case ')': {
                    char symbol = ')';
                    while (symbol != '(') {
                        symbol = pop_symbol(cur);
                        if (symbol == '(') break;
                        fprintf(f_out, "%c ", symbol);
                    }
                    break;
                }
                case '+': {
                    while (cur->last != -1) {
                        char symbol = peek_symbol(cur);
                        if (!sign(symbol)) break;
                        pop_symbol(cur);
                        fprintf(f_out, "%c ", symbol);
                    }
                    add_symbol(cur, c);
                    break;
                }
                case '-': {
                    while (cur->last != -1) {
                        char symbol = peek_symbol(cur);
                        if (!sign(symbol)) break;
                        pop_symbol(cur);
                        fprintf(f_out, "%c ", symbol);
                    }
                    add_symbol(cur, c);
                    break;
                }
                case '*': {
                    char symbol;
                    if (cur->last != -1) symbol = peek_symbol(cur);
                    while (cur->last != -1 && (symbol == '*' || symbol == '/')) {
                        pop_symbol(cur);
                        fprintf(f_out, "%c ", symbol);
                        symbol = peek_symbol(cur);
                    }
                    add_symbol(cur, c);
                    break;
                }
                case '/': {
                    char symbol = peek_symbol(cur);
                    while (cur->last != -1 && (symbol == '*' || symbol == '/')) {
                        pop_symbol(cur);
                        fprintf(f_out, "%c ", symbol);
                        symbol = peek_symbol(cur);
                    }
                    add_symbol(cur, c);
                    break;
                }
                default:
                    break;
            }
        }
        flag = false;
    }
    while (cur->last != -1) {
        char symbol = pop_symbol(cur);
        fprintf(f_out, "%c ", symbol);
    }
    fprintf(f_out, ".");
}

long long int solve (bool *flag, FILE *f_in) {
    Stack *cur = init();
    char c;
    *flag = false;
    while ((c = fgetc(f_in)) != EOF) {
        if (c == ' ' || c == '.') continue;
        if (number(c)) {
            long long int tmp = c - '0';
            while (number(c = fgetc(f_in))) {
                tmp *= 10;
                tmp += c - '0';
            }
            add(cur, tmp);
            *flag = true;
        } else if (c == '-') {
            long long int tmp = -1;
            while (number(c = fgetc(f_in))) {
                if (tmp == -1) tmp = 0;
                tmp += c - '0';
                tmp *= 10;
            }
            if (tmp != -1) {
                add(cur, (-1) * tmp / 10);
                *flag = true;
            } else {
                long long int first = pop(cur);
                long long int second = pop(cur);
                add(cur, second - first);
            }
        } else {
            long long int first = pop(cur);
            long long int second = pop(cur);
            switch (c) {
                case '+':
                    add(cur, first + second);
                    break;
                case '*':
                    add(cur, first * second);
                     break;
                case '-':
                    add(cur, second - first);
                    break;
                case '/':
                    add(cur, second / first);
                    break;
                default:
                    break;
            }
        }
        if (c == '.') break;
    }
    return cur->arr[0];
}

int main(void) {
    FILE *f_in = fopen("input.txt", "r");
    FILE *f_out = fopen("output.txt", "r+");
    convert_to_polish_notation(f_in, f_out);
    fseek(f_out, 0, SEEK_SET);
    bool flag;
    long long int ans = solve(&flag, f_out);
    fclose(f_out);
    f_out = fopen("output.txt", "w");
    if (flag) fprintf(f_out, "%lld", ans);
    fclose(f_in);
    fclose(f_out);
    return 0;
}