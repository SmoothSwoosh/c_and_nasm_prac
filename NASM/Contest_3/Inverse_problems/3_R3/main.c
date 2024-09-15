#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

int main(void) {
    int a, b, c;

    scanf("%d%d%d", &a, &b, &c);

    while (true) {
        if (a < b) {
            a ^= b;
            b ^= a;
            a ^= b;
        }
        if (a <= c) break;
        a ^= c;
        c ^= a;
        a ^= c;
    }
    printf("%d", a);

    return 0;
}
