#include <stdint.h>

void* sbrk(intptr_t increment) {
    intptr_t before = __builtin_wasm_memory_size(0) << 16;
    __builtin_wasm_memory_grow(0, increment >> 16);
    return (void*)before;
}
