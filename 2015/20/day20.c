#include <janet.h>
#include <stdint.h>

static Janet divisor(int32_t argc, Janet *argv) {
    // get the input Array from the user
    janet_fixarity(argc, 1);
    int32_t n = janet_getinteger(argv, 0);
    
    JanetArray *arr = janet_array(n + 1);

    // initialize the array
    for (int i = 0; i <= n; i++) {
        janet_array_push(arr, janet_wrap_number(0));
    }

    // count divisors / AKA deliver presents
    for (int i = 1; i <= n; i++) {
        for (int j = i; j <= n; j += i) {
            arr->data[j] = janet_wrap_number(i + janet_unwrap_integer(arr->data[j]));
        }
    }

    return janet_wrap_array(arr);   
}

static Janet part2(int32_t argc, Janet *argv) {
    // get the input Array from the user
    janet_fixarity(argc, 1);
    int32_t n = janet_getinteger(argv, 0);
    
    JanetArray *arr = janet_array(n + 1);

    // initialize the array
    for (int i = 0; i <= n; i++) {
        janet_array_push(arr, janet_wrap_number(0));
    }

    // deliver presents
    for (int i = 1; i <= n; i++) {
        for (int j = 1; j <= 50 && i * j <= n; j ++) {
            int k = i * j;
            arr->data[k] = janet_wrap_number(11 * i + janet_unwrap_integer(arr->data[k]));
        }
    }

    return janet_wrap_array(arr);   
}

static const JanetReg cfuns[] = {
    {"divisor", divisor, "(day20/divisor)\n\nCompute an array of divisor function values."},
    {"part2", part2, "(day20/part2)\n\nDeliver presents according to part 2."},
    {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "day20", cfuns);
}