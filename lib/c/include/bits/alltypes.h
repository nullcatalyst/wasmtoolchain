#ifdef __cplusplus
extern "C" {
#endif

#if defined(__NEED_NULL) && !defined(__DEFINED_NULL)
#define __DEFINED_NULL

#if __cplusplus >= 201103L
#define NULL nullptr
#elif defined(__cplusplus)
#define NULL 0L
#else
#define NULL ((void*)0)
#endif
#endif

#if defined(__NEED_sized_int_t) && !defined(__DEFINED_sized_int_t)
#define __DEFINED_sized_int_t

typedef signed char   int8_t;
typedef unsigned char uint8_t;

typedef signed short   int16_t;
typedef unsigned short uint16_t;

typedef signed int   int32_t;
typedef unsigned int uint32_t;

#if __LP64__
typedef signed long   int64_t;
typedef unsigned long uint64_t;
#else
typedef signed long long   int64_t;
typedef unsigned long long uint64_t;
#endif

typedef int64_t  intmax_t;
typedef uint64_t uintmax_t;
#endif

#if defined(__NEED_ptrdiff_t) && !defined(__DEFINED_ptrdiff_t)
#define __DEFINED_ptrdiff_t

#if __LP64__
typedef signed long   intptr_t;
typedef unsigned long uintptr_t;
typedef signed long   ptrdiff_t;
#else
typedef signed long long   intptr_t;
typedef unsigned long long uintptr_t;
typedef signed long long   ptrdiff_t;
#endif
#endif

#if defined(__NEED_size_t) && !defined(__DEFINED_size_t)
#define __DEFINED_size_t

#if __LP64__
typedef signed long   ssize_t;
typedef unsigned long size_t;
#else
typedef signed long long   ssize_t;
typedef unsigned long long size_t;
#endif
#endif

#if defined(__NEED_wchar_t) && !defined(__DEFINED_wchar_t)
#define __DEFINED_wchar_t

// The type wchar_t appears to be defined by the compilation unit itself
// typedef int wchar_t;
#endif

#ifdef __cplusplus
}  // extern "C"
#endif
