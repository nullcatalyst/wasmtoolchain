#include <math.h>

#include "wasm_import.h"

WASM_IMPORT(math, log) double _log_impl(double);
WASM_IMPORT(math, exp) double _exp_impl(double);
WASM_IMPORT(math, sqrt) double _sqrt_impl(double);
WASM_IMPORT(math, sin) double _sin_impl(double);
WASM_IMPORT(math, cos) double _cos_impl(double);
WASM_IMPORT(math, tan) double _tan_impl(double);
WASM_IMPORT(math, atan2) double _atan2_impl(double, double);

double log(double x) { return _log_impl(x); }
double exp(double x) { return _exp_impl(x); }
double sqrt(double x) { return _sqrt_impl(x); }
double sin(double x) { return _sin_impl(x); }
double cos(double x) { return _cos_impl(x); }
double tan(double x) { return _tan_impl(x); }
double atan2(double y, double x) { return _atan2_impl(y, x); }

float logf(float x) { return _log_impl(x); }
float expf(float x) { return _exp_impl(x); }
float sqrtf(float x) { return _sqrt_impl(x); }
float sinf(float x) { return _sin_impl(x); }
float cosf(float x) { return _cos_impl(x); }
float tanf(float x) { return _tan_impl(x); }
float atan2f(float y, float x) { return _atan2_impl(y, x); }
