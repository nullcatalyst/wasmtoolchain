#if defined(__NEED_NULL)
#if __cplusplus >= 201103L
#define NULL nullptr
#elif defined(__cplusplus)
#define NULL 0L
#else
#define NULL ((void*)0)
#endif
#endif

#if defined(__NEED_sized_int_t)
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
#endif

#if defined(__NEED_ptrdiff_t)
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

#if defined(__NEED_size_t)
#if __LP64__
typedef signed long   ssize_t;
typedef unsigned long size_t;
#else
typedef signed long long   ssize_t;
typedef unsigned long long size_t;
#endif
#endif

#if defined(__NEED_wchar_t)
typedef int wchar_t;
#endif
