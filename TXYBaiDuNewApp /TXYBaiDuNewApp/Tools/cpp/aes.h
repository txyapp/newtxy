#ifndef AES_H_
#define AES_H_

typedef enum {
	K_128,
	K_196,
	K_256
} KEY_SIZE;

typedef	unsigned char		__uint8_t;
typedef __uint8_t     uint8_t;

/**
 * encrypt
 */
int t1(uint8_t* key, KEY_SIZE ksize, const char* in, const int insize, char* out, int* outsize);

/**
 * decrypt
 */
int t2(uint8_t* key, KEY_SIZE ksize, const char* in, const int insize, char* out, int* outsize);

#endif /* AES_H_ */
