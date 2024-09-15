#include <stdio.h>
#include <stdlib.h>

int main(void)
{
    unsigned int ecx, edx;
    int eax, ebx;
    scanf("%u", &ecx);
    edx = 0;
    int last_bit = ecx & 1;
    ecx >>= 1;
    if (!last_bit) {
        for (int i = ecx; i > 0; --i) {
            scanf("%d %d", &eax, &ebx);
            eax *= ebx;
            edx += eax;
        }
    }
    printf("%d\n", edx);
    eax = 0;

    return 0;
}
