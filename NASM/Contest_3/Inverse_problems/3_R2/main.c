#include <stdio.h>
#include <stdlib.h>

int main(void) {

    int a, b;
    char c;
    scanf("%d%c%d", &a, &c, &b);
    int ans = 0;
    if (c == '+') {
        ans = a + b;
    } else if (c == '-') {
        ans = a - b;
    } else if (c == '*') {
        ans = a * b;
    } else {
        ans = a / b;
    }
    printf("%d", ans);

    return 0;
}
