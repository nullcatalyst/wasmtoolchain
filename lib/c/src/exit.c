#include <stdlib.h>

#include "wasm_import.h"

WASM_IMPORT(env, exit)
_Noreturn void exit(int);
