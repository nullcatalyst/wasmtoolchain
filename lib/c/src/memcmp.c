#include <string.h>

#undef memcmp

int memcmp(const void* vl, const void* vr, size_t n) {
    const unsigned char *l = vl, *r = vr;
    for (; n && *l == *r; n--, l++, r++) {
        // continue;
    }
    return n ? *l - *r : 0;
}
