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

#ifdef __cplusplus
}  // extern "C"
#endif
