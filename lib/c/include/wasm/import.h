#pragma once

#if __wasm__
#define WASM_IMPORT($module, $name) __attribute__((import_module(#$module), import_name(#$name)))
#else
#define WASM_IMPORT($module, $name)
#endif
