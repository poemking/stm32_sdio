#ifndef __STRING_H
#define __STRING_H

#include <stddef.h>

char *strcat(char* dst, char* src);
char *strcpy(char *dest, const char *src);
size_t strlen(const char *s);

void *memset(void *dest, int c, size_t n);

#endif
