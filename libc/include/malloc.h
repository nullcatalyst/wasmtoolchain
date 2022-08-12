#pragma once

#define __NEED_size_t
#include <bits/alltypes.h>

#ifdef __cplusplus
extern "C" {
#endif

void* malloc(size_t size);
void* calloc(size_t size, size_t count);
void* realloc(void* ptr, size_t size);
void  free(void* ptr);

int    posix_memalign(void** memptr, size_t alignment, size_t size);
void*  aligned_alloc(size_t alignment, size_t bytes);
size_t malloc_usable_size(void* ptr);

#ifdef __cplusplus
}  // extern "C"
#endif
