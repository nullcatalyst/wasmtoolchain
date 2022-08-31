#define CHAR_BIT 8

typedef long long          di_int;
typedef unsigned long long du_int;

typedef int      ti_int __attribute__((mode(TI)));
typedef unsigned tu_int __attribute__((mode(TI)));

typedef union {
    ti_int all;
    struct {
#if _YUGA_LITTLE_ENDIAN
        du_int low;
        di_int high;
#else
        di_int high;
        du_int low;
#endif  // _YUGA_LITTLE_ENDIAN
    } s;
} twords;

typedef union {
    tu_int all;
    struct {
#if _YUGA_LITTLE_ENDIAN
        du_int low;
        du_int high;
#else
        du_int high;
        du_int low;
#endif  // _YUGA_LITTLE_ENDIAN
    } s;
} utwords;

static ti_int __mulddi3(du_int a, du_int b) {
    twords       r;
    const int    bits_in_dword_2 = (int)(sizeof(di_int) * CHAR_BIT) / 2;
    const du_int lower_mask      = (du_int)~0 >> bits_in_dword_2;
    r.s.low                      = (a & lower_mask) * (b & lower_mask);
    du_int t                     = r.s.low >> bits_in_dword_2;
    r.s.low &= lower_mask;
    t += (a >> bits_in_dword_2) * (b & lower_mask);
    r.s.low += (t & lower_mask) << bits_in_dword_2;
    r.s.high = t >> bits_in_dword_2;
    t        = r.s.low >> bits_in_dword_2;
    r.s.low &= lower_mask;
    t += (b >> bits_in_dword_2) * (a & lower_mask);
    r.s.low += (t & lower_mask) << bits_in_dword_2;
    r.s.high += t >> bits_in_dword_2;
    r.s.high += (a >> bits_in_dword_2) * (b >> bits_in_dword_2);
    return r.all;
}

// Returns: a * b
ti_int __multi3(ti_int a, ti_int b) {
    twords x;
    x.all = a;
    twords y;
    y.all = b;
    twords r;
    r.all = __mulddi3(x.s.low, y.s.low);
    r.s.high += x.s.high * y.s.low + x.s.low * y.s.high;
    return r.all;
}
