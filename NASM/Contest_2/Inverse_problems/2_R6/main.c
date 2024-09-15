#include <stdio.h>
#include <stdbool.h>

int main(void)
{
    unsigned int ebx = 0xFFFFFFFF, eax;
    while (true) {
        scanf("%u", &eax);
        if (eax == 0) break;
        if (eax <= ebx) {
            ebx = eax;
        }
    }
    printf("%u", ebx);


    return 0;
}
