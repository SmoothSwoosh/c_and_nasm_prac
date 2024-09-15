#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    unsigned int eax, ebx = 0;
    scanf("%u", &eax);
    for (int i = 31; i >= 0; --i) {
        ebx <<= 1;
        int ecx = eax & 1;
        ebx |= ecx;
        eax >>= 1;
    }
    eax = ebx;

    printf("%u\n", eax);

    return 0;
}
