shader_type sky;

#include "simple.gdshaderinc"

uniform float scale = 5;
uniform vec3 skyColor1 : source_color;
uniform vec3 skyColor2 : source_color;

void sky() {
	//vec3 debug = vec3(sin(TIME));
	
	vec3 pos = EYEDIR * 0.5 + 0.5;
	
	float noise = fractal_noise(pos * scale, 5);
	
	COLOR = mix(skyColor1, skyColor2, noise);
}
