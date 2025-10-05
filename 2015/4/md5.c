#include <janet.h>
#include <openssl/md5.h>
#include <stdint.h>

static Janet md5(int32_t argc, Janet *argv) {
    // get the input string from the user
    janet_fixarity(argc, 1);
    JanetArray *arr = janet_getarray(argv, 0);
    unsigned char bytes[arr->count];

    // conver Array into c byte array
    for (int i = 0; i < arr->count; i++) {
        Janet datum = arr->data[i];
        int32_t d = janet_getinteger(&datum, 0);
        if (d >> 8 != 0) {
            janet_panicf("non-byte in position %d of array", i);
        }
        bytes[i] = d & 0xff;
    } 

    // compute the md5 hex digest
    unsigned char hash[MD5_DIGEST_LENGTH];
    MD5(bytes, arr->count, hash);

    // convert the digest to a string
    char digest[2 * MD5_DIGEST_LENGTH + 1] = {0};
    for (int i = 0; i < MD5_DIGEST_LENGTH; i++) {
        sprintf(&digest[2 * i], "%02x", hash[i]);
    } 

    return janet_cstringv(digest);
}

static const JanetReg cfuns[] = {
    {"md5", md5, "(md5/md5)\n\nComputes an md5 hash."},
    {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "md5", cfuns);
}