#pragma once

// Endianness

#define __LITTLE_ENDIAN 1234
#define __BIG_ENDIAN 4321
#define __PDP_ENDIAN 3412

#if defined(__GNUC__) && defined(__BYTE_ORDER__)
#define __BYTE_ORDER __BYTE_ORDER__
#endif

// Type limits

#define	SCHAR_MAX   127                         // min value for a signed char
#define	SCHAR_MIN   (-128)                      // max value for a signed char

#define	UCHAR_MAX   255                         // max value for an unsigned char
#define	CHAR_MAX    127                         // max value for a char
#define	CHAR_MIN    (-128)                      // min value for a char

#define	USHRT_MAX   65535                       // max value for an unsigned short
#define	SHRT_MAX    32767                       // max value for a short
#define	SHRT_MIN    (-32768)                    // min value for a short

#define	UINT_MAX    0xFFFFFFFF                  // max value for an unsigned int
#define	INT_MAX     2147483647                  // max value for an int
#define	INT_MIN     (-2147483647-1)             // min value for an int

#if __LP64__
#define	ULONG_MAX   0xFFFFFFFFFFFFFFFFul        // max unsigned long
#define	LONG_MAX    0x7FFFFFFFFFFFFFFFl         // max signed long
#define	LONG_MIN    (-0x7FFFFFFFFFFFFFFFl-1)    // min signed long
#else
#define	ULONG_MAX   0xFFFFFFFFul                // max unsigned long
#define	LONG_MAX    2147483647l                 // max signed long
#define	LONG_MIN    (-2147483647l-1)            // min signed long
#endif

#define	ULLONG_MAX  0xFFFFFFFFFFFFFFFFull       // max unsigned long long
#define	LLONG_MAX   0x7FFFFFFFFFFFFFFFll        // max signed long long
#define	LLONG_MIN   (-0x7FFFFFFFFFFFFFFFll-1)   // min signed long long
