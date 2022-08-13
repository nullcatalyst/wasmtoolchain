#include <stdlib.h>

#include "wasm_import.h"

WASM_IMPORT(env, exit)
_Noreturn void _exit_impl(int);

_Noreturn void exit(int exit_code) { _exit_impl(exit_code); }
