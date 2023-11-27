shader_type spatial;
render_mode unshaded;

uniform float radius = 1.0;
uniform float k = 1.0;
uniform vec3 color = vec3(1.0);

varying flat mat4 inv_modelview_matrix;
varying flat mat4 modelview_matrix;
varying flat vec3 zero_point;

vec3 view_point(vec3 p, mat4 matrix) {
	vec4 v = matrix * vec4(p, 1.0);
	return v.xyz / v.w;
}

void vertex() {
	modelview_matrix = MODELVIEW_MATRIX;
	inv_modelview_matrix = inverse(MODELVIEW_MATRIX);
}

void fragment() {
	vec2 vert = view_point(VERTEX, inv_modelview_matrix).xz;
	vec2 p1 = view_point(vec3(0.0), inv_modelview_matrix).xz;
	vec2 p2 = vec2(0);
	vec2 v1 = vert - p1;
	vec3 v2 = vec3(0, 1, 0);

	vec2 delta = p1 + v1 * dot(p2 - p1, v1) / dot(v1, v1);
	delta = delta / radius;
	float l = (dot(delta, delta));

	float v = 1.1 - l;
	v = v * v;
	v = v * v;
	v = v * v * 0.5;
	v = v * k;
	v = min(v, 1.0);
	ALPHA = v;
	ALBEDO = vec3(1) * v + color * (1.0 - v);
}
