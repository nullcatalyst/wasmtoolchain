#pragma once

#if __wasm__
#define WASM_EXPORT($name) __attribute__((export_name(#$name)))
#else
#define WASM_EXPORT($name)
#endif
