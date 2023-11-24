shader_type spatial;

varying vec3 instance_pos;

void vertex() {
	instance_pos = VERTEX;
}

#include "simple.gdshaderinc"

uniform float scale;
uniform float speed;
uniform vec3 color : source_color;
uniform vec3 color2 : source_color;

void fragment() {
	vec3 wrld_vertex = instance_pos;

	float noise = fractal_noise(wrld_vertex * scale, 5);
	ALBEDO = mix(color, color2, noise * noise);
}
