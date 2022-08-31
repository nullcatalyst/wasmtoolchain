#include <stdlib.h>

extern "C" void __cxa_pure_virtual() { abort(); }

extern "C" int __cxa_atexit(void (*func)(void*), void* arg, void* dso_handle) {
    // This is normally called in order to run the destructors of global objects
    // Since that will never actually happen in (our) wasm, we can safely ignore these calls
    return 0;
}

// These are what the clang+linker wasm backend generates in order to actually run the global object ctors/dtors
// Since we won't be using those either, we can create a main() that calls them to trick the linker into thinking that
// we used them. And then by not exporting main(), main() will be removed tricking it into also removing the
// __wasm_call_ctors() and __wasm_call_dtors()
extern "C" void __wasm_call_ctors();
// extern "C" void __wasm_call_dtors();

int main() {
    __wasm_call_ctors();
    // __wasm_call_dtors();
    return 0;
}
