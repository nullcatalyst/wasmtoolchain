#pragma once

#define __NEED_NULL
#define __NEED_size_t
#define __NEED_wchar_t
#include <bits/alltypes.h>

#ifdef __cplusplus
extern "C" {
#endif

void* memcpy(void* __restrict, const void* __restrict, size_t);
void* memmove(void*, const void*, size_t);
void* memset(void*, int, size_t);
int   memcmp(const void*, const void*, size_t);

#if __has_builtin(__builtin_memcpy)
#define memcpy __builtin_memcpy
#endif

#if __has_builtin(__builtin_memmove)
#define memmove __builtin_memmove
#endif

#if __has_builtin(__builtin_memset)
#define memset __builtin_memset
#endif

#if __has_builtin(__builtin_memcmp)
#define memcmp __builtin_memcmp
#endif

int    strcmp(const char* l, const char* r);
char*  strcpy(char* __restrict d, const char* __restrict s);
char*  strncpy(char* __restrict, const char* __restrict, size_t);
size_t strlen(const char* s);

char* strchr(const char*, int);
char* strrchr(const char*, int);
char* strcat(char* __restrict, const char* __restrict);
char* strncat(char* __restrict, const char* __restrict, size_t);

char* strstr(const char*, const char*);

#if __has_builtin(__builtin_strcmp)
#define strcmp __builtin_strcmp
#endif

#if __has_builtin(__builtin_strcpy)
#define strcpy __builtin_strcpy
#endif

#if __has_builtin(__builtin_strlen)
#define strlen __builtin_strlen
#endif

#ifdef __cplusplus
}  // extern "C"
#endif
