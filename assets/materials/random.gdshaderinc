const int HashSeed = 0;

int hash_1(int v) {
    v ^= HashSeed * 216091 >> 2;
    v ^= v * 524287 >> 5;
    v ^= v * 131071 >> 2;
    return v;
}

int hash_2(int x, int y) {
    return hash_1(x ^ hash_1(y));
}

int hash_3(int x, int y, int s) {
    return hash_1(s ^ hash_2(x, y));
}

int hash_4(int x, int y, int z, int s) {
    return hash_1(s ^ hash_3(x, y, z));
}

#define RANDOM_MOD 10000

float u_random(int hash) {
    return float(abs(hash) % RANDOM_MOD) / float(RANDOM_MOD);
}

float s_random(int hash) {
    return u_random(hash) * 2.0 - 1.0;
}