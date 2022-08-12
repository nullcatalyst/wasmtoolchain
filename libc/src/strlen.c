#include <limits.h>
#include <stdint.h>
#include <string.h>

#undef strlen

#define ALIGN (sizeof(size_t))
#define ONES ((size_t)-1 / UCHAR_MAX)
#define HIGHS (ONES * (UCHAR_MAX / 2 + 1))
#define HASZERO(x) ((x)-ONES & ~(x)&HIGHS)

size_t strlen(const char* s) {
    const char* a = s;
#ifdef __GNUC__
    typedef size_t __attribute__((__may_alias__)) word;
    const word* w;
    for (; (uintptr_t)s % ALIGN; s++) {
        if (!*s) {
            return s - a;
        }
    }
    for (w = (const void*)s; !HASZERO(*w); w++) {
        // continue;
    }
    s = (const void*)w;
#endif
    for (; *s; s++) {
        // continue;
    }
    return s - a;
}
