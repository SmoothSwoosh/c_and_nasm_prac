#include <stdio.h>
#include <stdlib.h>

int main(void) {
    unsigned int a;
    scanf("%u", &a);

    int b = a;
    --b;
    a ^= b;
    a = a + 1;

    printf("%u", a);
    printf("\n");

    a = 0;
    return 0;
}
