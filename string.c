#include <stddef.h>
#include <stdint.h>
#include <limits.h>

#define ALIGN (sizeof(size_t))
#define ONES ((size_t)-1/UCHAR_MAX)                                                                      
#define HIGHS (ONES * (UCHAR_MAX/2+1))
#define HASZERO(x) ((x)-ONES & ~(x) & HIGHS)

#define SS (sizeof(size_t))

char *strcat(char* dst, char* src)
{
        if(src == NULL)
                return NULL;

        char* retAddr = dst;

        /* --- Find last position --- */
        while (*dst++ != '\0');

        dst--;
        while (*dst++ = *src++);
        return retAddr;
}

void *memset(void *dest, int c, size_t n)
{
        unsigned char *s = dest;
        c = (unsigned char)c;
        for (; ((uintptr_t)s & ALIGN) && n; n--) *s++ = c;
        if (n) {
                size_t *w, k = ONES * c;
                for (w = (void *)s; n>=SS; n-=SS, w++) *w = k;
                for (s = (void *)w; n; n--, s++) *s = c;
        }
        return dest;
}
