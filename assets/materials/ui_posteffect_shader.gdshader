shader_type canvas_item;

uniform float k = 1.0;

void fragment() {
	if (k < 0.01) {
		COLOR = vec4(0);
	} else {
		float value = 0.9 + (sin((UV.y - TIME) * 400.0) + 1.0) * 0.5 * 0.1;
		COLOR = vec4(vec3(0), (1.0 - value) * k);
	}
}
