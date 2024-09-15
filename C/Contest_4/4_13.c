#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdbool.h>

struct Pair {
  char *str, *cmp;
};

void swap (struct Pair *a, struct Pair *b) {
  struct Pair tmp = *a;
  *a = *b;
  *b = tmp;
}

bool strcmpy (struct Pair a, struct Pair b) {
  if ((a.cmp[0] - '0' <= 9 && a.cmp[0] - '0' >= 0) || (a.cmp[0] == '-' || b.cmp[0] == '-')) {
    if (atoi(a.cmp) >= atoi(b.cmp)) {
      return false;
    } else {
      return true;
    }
  }
  return strcmp(a.cmp, b.cmp) < 0;
}

void quick_sort(struct Pair *arr, int size) {
  int i = 0, j = size - 1;
  struct Pair mid = arr[size / 2];

  do {
    while (strcmpy(arr[i], mid)) {
      ++i;
    }
    while (strcmpy(mid, arr[j])) {
      --j;
    }
    if (i <= j) {
      swap(&arr[i], &arr[j]);
      ++i, --j;
    }
  } while (i <= j);

  if (j > 0) {
    quick_sort(arr, j + 1);
  }
  if (i < size) {
    quick_sort(&arr[i], size - i);
  }
}

char * without_spaces (char *str) {
  bool flag = false;
  int start = 0, last = strlen(str) - 1;
  while (str[start] == ' ') {
    ++start;
  }
  if (str[start] == '"') {
    flag = true;
  }
  last = start + 1;
  char symbol = (flag) ? '"' : ' ';
  while (last < strlen(str) && str[last] != symbol) {
    ++last;
  }
  char *tmp;
  tmp = (char *)malloc((last - start + 2) * sizeof(char));
  for (int i = 0; i < last - start + 1; ++i)
    tmp[i] = str[start + i];
  return tmp;
}

struct Pair make_Pair (char *a, char *b) {
  struct Pair cur;
  char *a_new = (char *) malloc (101*sizeof(char));
  strcpy(a_new, a);
  char *b_new = (char *) malloc (101*sizeof(char));
  strcpy(b_new, b);
  cur.str = a_new, cur.cmp = b_new;
  return cur;
}

int main(void) {
  char *str, *tmp;
  str = (char *)malloc(101 * sizeof(char));
  tmp = (char *)malloc(101 * sizeof(char));
  struct Pair strings[10001];
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  int n = 0, len = 0;
  fscanf(f_in, "%d\n", &n);
  while (fgets(str, 101, f_in) != NULL) {
    int index = 0, last = 0, i = 0;
    if (str[strlen(str) - 1] == '\n')
      str[strlen(str) - 1] = '\0';
    for (i = 0; i < strlen(str); ++i) {
      if (last == n) {
        break;
      }
      if (str[i] == ';') {
        ++last;
      }
    }
    while (str[i] == ' ') {
      ++i;
    }
    if (str[i] == '"') {
      do {
        tmp[index] = str[i];
        ++i;
        ++index;
      } while (str[i] != '"');
    } else {
      do {
        tmp[index] = str[i];
        ++i;
        ++index;
      } while (!(str[i] == ' ' || str[i] == '\n' || str[i] == '\0' || str[i] == ';'));
    }
    tmp[index] = '\0';
    strings[len++] = make_Pair(str, tmp);
  }
  quick_sort(strings, len);
  for (int i = 0; i < len; ++i) {
    int space = 0;
    for (int j = 0; j < strlen(strings[i].str); ++j) {
      if (strings[i].str[j] == '"') {
        space = !space;
      }
      if (strings[i].str[j] == ' ') {
        if (space) {
          fprintf(f_out, "%c", strings[i].str[j]);
        }
      } else {
        fprintf(f_out, "%c", strings[i].str[j]);
      }
    }
    fprintf(f_out, "\n");
  }

  for (int i = 0; i < len; ++i) {
    free(strings[i].str);
    free(strings[i].cmp);
  }

  fclose(f_in);
  fclose(f_out);
  free(str);
  free(tmp);
  return 0;
}