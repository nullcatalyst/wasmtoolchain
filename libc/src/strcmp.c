#include <string.h>

#undef strcmp

int strcmp(const char* l, const char* r) {
    for (; *l == *r && *l; l++, r++) {
        // continue;
    }
    return *(unsigned char*)l - *(unsigned char*)r;
}
