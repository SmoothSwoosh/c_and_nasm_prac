#include <stdio.h>
#include <stdbool.h>
#include <stdlib.h>
#define MaxSize 10000000

int n;
bool visited[200][200];
int dist[200][200];

struct pair {
  int x, y;
};

struct queue {
  int front, rear, nitems;
  struct pair *queArray;
};

struct pair make_pair (int x, int y) {
  struct pair tmp;
  tmp.x = x;
  tmp.y = y;
  return tmp;
}

void init (struct queue *q) {
  q->queArray =(struct pair *) malloc (MaxSize * sizeof(char));
  q->front = 0;
  q->rear = -1;
  q->nitems = 0;
}

void destruct (struct queue *q) {
  free(q->queArray);
  return;
}

void insert (struct queue *q, struct pair x) {
  if (q->rear == MaxSize - 1) {
    q->rear = -1;
    q->nitems = 0;
  }
  q->queArray[++q->rear] = x;
  q->nitems++;
}

struct pair pop (struct queue *q) {
  struct pair tmp = q->queArray[q->front++];
  if (q->front == MaxSize)
    q->front = 0;
  q->nitems--;
  return tmp;
}

struct pair peekFront (struct queue *q) {
  return q->queArray[q->front];
}

bool isEmpty (struct queue *q) {
  return (q->nitems == 0);
}

bool isFull (struct queue *q) {
  return (q->nitems == MaxSize);
}

int size (struct queue *q) {
  return (q->nitems);
}

void display (struct queue *q) {
  if (q->nitems == 0) {
    printf("Empty\n");
    return;
  }
  if (q->front > q->rear) {
    int j = q->front;
    while (j != MaxSize) {
      printf("%d %d\n", q->queArray[j].x, q->queArray[j].y);
      j++;
    }
    j = 0;
    while (j <= q->rear) {
      printf("%d %d\n", q->queArray[j].x, q->queArray[j].y);
      j++;
    }
  } else if (q->front < q->rear) {
    for (int i = q->front; i <= q->rear; i++) {
        printf("%d %d\n", q->queArray[i].x, q->queArray[i].y);
    }
  } else if (q->nitems == 1) {
    printf("%d %d\n", q->queArray[q->front].x, q->queArray[q->front].y);
  }
  printf("\n");
}

bool not_visited (int x, int y) {
  return x >= 0 && y >= 0 && x < n && y < n && !visited[x][y];
}

int main(void) {
  
  scanf("%d", &n);
  int x1, y1, x2, y2;
  scanf("%d%d%d%d", &x1, &y1, &x2, &y2);
  x1--, x2--, y1--, y2--;
  for (int i = 0; i < n; i++)
    for (int j = 0; j < n; j++)
      dist[i][j] = -1;
  
  struct queue *q;
  q = (struct queue*)malloc(sizeof(struct queue));
  init(q);
  insert(q, make_pair(x1, y1));
  visited[x1][y1]= true;
  dist[x1][y1] = 0;

  while (!isEmpty(q)) {
    struct pair current = peekFront(q);
    pop(q);
    int cx = current.x, cy = current.y;
    struct pair moves[8] = {make_pair(-2, -1), make_pair(-2, 1), make_pair(1, 2), make_pair(1, -2), make_pair(-1, 2), make_pair(-1, -2), make_pair(2, 1), make_pair(2, -1)};
    for (int i = 0; i < 8; i++) {
      int dx = moves[i].x, dy = moves[i].y;
      if (not_visited(cx + dx, cy + dy)) {
        insert(q, make_pair(cx + dx, cy + dy));
        visited[cx + dx][cy + dy] = true;
        dist[cx + dx][cy + dy] = dist[cx][cy] + 1;
      }
    } 
  }

  printf("%d", dist[x2][y2]);

  destruct(q);

  return 0;
}