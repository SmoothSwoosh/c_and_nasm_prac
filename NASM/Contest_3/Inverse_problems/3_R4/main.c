#include <stdio.h>
#include <stdlib.h>
#include <string.h>

unsigned int hashes(unsigned char *s) {
    int i, j;
    unsigned int symb, ans, tmp;

    i = 0;
    ans = 0xFFFFFFFF;
    while (s[i] != 0) {
        symb = s[i];
        ans = ans ^ symb;
        for (j = 7; j >= 0; --j) {
            tmp = -(ans & 1);
            ans = (ans >> 1) ^ (0xEDB88320 & tmp);
        }
        ++i;
    }
    return ~ans;
}

int main(void)
{
    char s[100000];
    fgets(s, 100000, stdin);
    int ans = hashes(s);
    printf("%x", ans);

    return 0;
}

