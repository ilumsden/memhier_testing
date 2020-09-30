#include <stdio.h>
#include <stdlib.h>
#include <errno.h>

const char usage [] =
"Usage: truncate LENGTH\n"
"Read memory references from stdin and truncate all addresses to the\n"
"specified length. Print references with truncated addresses to stdout.\n"
"LENGTH must be greater than 0 and less than or equal to 32.\n";

int main(int argc, char **argv)
{
    FILE *f;
    unsigned long long newLength, addr, mask;
    char buf[256];
    char accessType;
    unsigned long long maskSize = 64;

    if(argc != 2)
    {
        printf(usage);
        return -EINVAL;
    }

    newLength = atoi(argv[1]);
    if( (newLength) < 1 || (newLength > 32) )
    {
        printf(usage);
        return -EINVAL;
    }

    mask = ~0;

    mask <<= maskSize - newLength;
    mask >>= maskSize - newLength;

    if(newLength == 0)
    {
        mask = 0;
    }

    while(scanf("%c:%s\n", &accessType, buf) == 2)
    {
        addr = strtoull(buf, NULL, 16);
        addr &= mask;
        printf("%c:%llx\n",accessType, addr);
    }

    return 0;
}
