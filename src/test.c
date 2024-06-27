#include <stdio.h>
#include <inttypes.h>

typedef struct {
	uint8_t a;
	uint32_t b;
	uint8_t c;
} S;

void dump(S s) {
	printf("S{ a: %d, b: %d, c: %d }\n", s.a, s.b, s.c);
}