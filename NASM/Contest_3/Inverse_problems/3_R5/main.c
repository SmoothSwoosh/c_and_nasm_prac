#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(void)
{
    int n;
    char s1[4096], s2[4096], s[4096];
    fgets(s1, 4096, stdin);
    fgets(s2, 4096, stdin);
    scanf("%d\n", &n);
    while (n--) {
        fgets(s, 4096, stdin);
        for (int i = 0; i < strlen(s); ++i) {
            int j = strlen(s1) - 1;
            for (; j >= 0; --j) {
                if (s1[j] == s[i]) break;
            }
            if (j != -1) s[i] = s2[j];
        }
        printf("%s", s);
    }


    return 0;
}
