#include <stdio.h>
#include <stdlib.h>

int main(void) {

    unsigned int a;
    scanf("%u", &a);
    unsigned int ans = 1;
    for (int i = 0; i < a; ++i) ans *= 3;
    printf("%u", ans);

    return 0;
}
