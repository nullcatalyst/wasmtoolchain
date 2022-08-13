#include <stdlib.h>

#include "wasm_import.h"

WASM_IMPORT(env, abort)
_Noreturn void abort(void);
