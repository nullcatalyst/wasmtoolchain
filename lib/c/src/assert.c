#include <assert.h>
#include <stdlib.h>

_Noreturn void __assert_fail(const char* cond, const char* file, int line, const char* func) { abort(); }
