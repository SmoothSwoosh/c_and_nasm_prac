#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

struct List {
  int x, items;
  struct List *next;
};

struct List *rear;

struct List * init (int num) {
  struct List *l;
  l = (struct List *)malloc(sizeof(struct List));
  l->x = num;
  l->next = NULL;
  l->items = 1;
  rear = l;
  return l;
}

void push (struct List *l, int num) {
  struct List *tmp;
  tmp = (struct List *)malloc(sizeof(struct List));
  l->next = tmp;
  ++l->items;
  tmp->x = num;
  tmp->next = NULL;
  tmp->items = l->items;
  rear = tmp;
}

int numbers (struct List *l) {
  return l->items;
}

void destruct (struct List *l) {
  struct List *tmp;
  while (l != NULL) {
    tmp = l;
    l = tmp->next;
    free(tmp);
  }
}

void output (FILE *f, struct List *l) {
  while (l != NULL) {
    fprintf(f, "%d ", l->x);
    l = l->next;
  }
}

struct List *MergeSortedList(struct List *lst1, struct List *lst2) 
{ 
	struct List *result = NULL; 
	if (lst1 == NULL) 
		return (lst2); 
	else if (lst2 == NULL) 
		return (lst1); 
	if (lst1->x <= lst2->x) { 
		result = lst1; 
		result->next = MergeSortedList(lst1->next, lst2); 
	} 
	else { 
		result = lst2; 
		result->next = MergeSortedList(lst1, lst2->next); 
	} 
	return result; 
} 

void SplitList(struct List *root, struct List **first, struct List **rear) 
{ 
	struct List *start; 
	struct List *end; 
	end =root; 
	start = root->next; 

	while (start != NULL) { 
		start = start->next; 
		if (start != NULL) { 
			end = end->next; 
			start = start->next; 
		} 
	} 

	*first = root; 
	*rear = end->next; 
	end->next = NULL; 
} 

void MergeSort(struct List **thead) 
{ 
	struct List *head = *thead; 
	struct List *first; 
	struct List *second; 
	if ((head == NULL) || (head->next == NULL)) { 
		return; 
	} 
	SplitList(head, &first, &second); 
	MergeSort(&first); 
	MergeSort(&second); 
	*thead = MergeSortedList(first, second); 
} 

int main(void) {
  FILE *f_in, *f_out;
  f_in = fopen("input.txt", "r");
  f_out = fopen("output.txt", "w");
  struct List *l;
  l = (struct List *) malloc (sizeof(struct List));
  int x = 0, index = 0;
  while (fscanf(f_in, "%d", &x) == 1) {
    if (index == 0) {
      l = init(x);
      ++index;
    }
    else {
      push(rear, x);
    }
  }
  if (numbers(l) != 0) {
    MergeSort(&l);
    output(f_out, l);
  }

  fclose(f_in);
  fclose(f_out);
  destruct(l);

  return 0;
}