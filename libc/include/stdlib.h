#pragma once

#include <malloc.h>

#define __NEED_NULL
#define __NEED_size_t
#define __NEED_wchar_t
#include <bits/alltypes.h>

#if __STDC_VERSION__ >= 199901L || defined(__cplusplus)
#define __inline inline
#elif !defined(__GNUC__)
#define __inline
#endif

#if __STDC_VERSION__ >= 201112L
#elif defined(__cplusplus)
#define _Noreturn [[noreturn]]
#elif defined(__GNUC__)
#define _Noreturn __attribute__((__noreturn__))
#else
#define _Noreturn
#endif

#ifdef __cplusplus
extern "C" {
#endif

_Noreturn void abort(void);
_Noreturn void exit(int);

#ifdef __cplusplus
}  // extern "C"
#endif
