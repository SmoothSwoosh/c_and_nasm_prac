#include <stdio.h>
#include <stdlib.h>

int N, K;

int a[21], b[21];

int main(void)
{
    int eax;
    scanf("%d", &N);
    scanf("%d", &K);
    int *esi = &a[0];
    int *edi = &b[0];
    *esi = 1;
    int ecx = 0;
    for (;ecx < N;) {
        ++ecx;
        *edi = 1;
        int edx = 0;
        for (;edx < ecx;) {
            ++edx;
            eax = *(esi + edx);
            eax += *(esi + edx - 1);
            *(edi + edx) = eax;
        }
        *(edi + edx) = 1;
        int *ebx = esi;
        esi = edi;
        edi = ebx;
    }
    *edi = K;
    eax = *(esi + *edi);
    printf("%d\n", eax);

    return 0;
}
