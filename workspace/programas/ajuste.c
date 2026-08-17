#include <stdio.h>

static int ajustar(int base, int incremento)
{
    return base + 1;
}

int main(void)
{
    printf("Valor ajustado: %d\n", ajustar(10, 5));
    return 0;
}
