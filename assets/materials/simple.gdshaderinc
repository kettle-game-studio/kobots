#include "random.gdshaderinc"

float simple_noise(vec3 pos) {
    ivec3 ipos = ivec3(floor(pos));
    ivec3 inxt = ivec3(floor(pos)) + ivec3(1);

    float p000 = u_random(hash_3(ipos.x, ipos.y, ipos.z));
    float p001 = u_random(hash_3(ipos.x, ipos.y, inxt.z));
    float p010 = u_random(hash_3(ipos.x, inxt.y, ipos.z));
    float p011 = u_random(hash_3(ipos.x, inxt.y, inxt.z));
    float p100 = u_random(hash_3(inxt.x, ipos.y, ipos.z));
    float p101 = u_random(hash_3(inxt.x, ipos.y, inxt.z));
    float p110 = u_random(hash_3(inxt.x, inxt.y, ipos.z));
    float p111 = u_random(hash_3(inxt.x, inxt.y, inxt.z));

    float r00 = mix(p000, p100, pos.x - float(ipos.x));
    float r10 = mix(p010, p110, pos.x - float(ipos.x));
    float r0 = mix(r00, r10, pos.y - float(ipos.y));

    float r01 = mix(p001, p101, pos.x - float(ipos.x));
    float r11 = mix(p011, p111, pos.x - float(ipos.x));
    float r1 = mix(r01, r11, pos.y - float(ipos.y));
	
	float r = mix(r0, r1, pos.z - float(ipos.z));

    return r;
}

float fractal_noise(vec3 pos, int iters) {
    float res = 0.0;
	float scale = 1.0;
	float sum = 0.0;

    for (int i = 0; i < iters; i++) {
        res += simple_noise(pos * scale) / scale;
   	 	sum += 1.0 / scale;
		scale *= 2.0;
    }
    
	
    return clamp(res / sum, 0.0, 1.0);
}

float star_size(ivec3 pos, float time) {
    return fractal_noise(vec3(pos) + vec3(time), 3) * 0.5 + 0.5;//, 3) * 0.5 + 0.5;
}
