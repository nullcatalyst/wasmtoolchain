#pragma once

#include <features.h>
#include <malloc.h>

#define __NEED_NULL
#define __NEED_size_t
#define __NEED_wchar_t
#include <bits/alltypes.h>

#define EXIT_FAILURE 1
#define EXIT_SUCCESS 0

#ifdef __cplusplus
extern "C" {
#endif

_Noreturn void abort(void);
_Noreturn void exit(int);

// Why these exist here instead of in math.h, I do not know
// But I am not about to try to change libc now...

int       abs(int);
long      labs(long);
long long llabs(long long);

// clang-format off
typedef struct { int quot, rem; } div_t;
typedef struct { long quot, rem; } ldiv_t;
typedef struct { long long quot, rem; } lldiv_t;
// clang-format on

div_t   div(int, int);
ldiv_t  ldiv(long, long);
lldiv_t lldiv(long long, long long);

#ifdef __cplusplus
}  // extern "C"
#endif
