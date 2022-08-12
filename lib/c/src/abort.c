#include <stdlib.h>
#include <wasm/import.h>

WASM_IMPORT(env, abort)
_Noreturn void abort(void);
