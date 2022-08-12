#include <stdlib.h>
#include <wasm/import.h>

WASM_IMPORT(env, exit)
_Noreturn void exit(int);
