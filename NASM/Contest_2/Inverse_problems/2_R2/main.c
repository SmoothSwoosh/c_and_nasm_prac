#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    unsigned int x;
    scanf("%u", &x);
    unsigned int xor_result = ((x - 1) ^ x) + 1;
    unsigned int flag = 0;
    if (xor_result == 0)
        flag = 1;
    unsigned int result = ((((x - 1) ^ x) + 1) >> 1) | (flag << 31);
    printf("%u", result);

    return 0;
}
