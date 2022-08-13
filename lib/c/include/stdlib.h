#pragma once

#include <features.h>
#include <malloc.h>

#define __NEED_NULL
#define __NEED_size_t
#define __NEED_wchar_t
#include <bits/alltypes.h>

#ifdef __cplusplus
extern "C" {
#endif

_Noreturn void abort(void);
_Noreturn void exit(int);

#ifdef __cplusplus
}  // extern "C"
#endif
