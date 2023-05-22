shader_type canvas_item;
render_mode skip_vertex_transform;

void fragment(){
	float alpha = 0.0;
	if (pow(UV.x - 0.5, 2.0) + pow(UV.y - 0.5, 2.0) < 0.25) {
		alpha = 1.0 * COLOR.a;
	}
	vec2 uv_def = vec2(0.025 * sin(UV.y * 50.0 * TIME / (PI * 5.0)) + UV.x, UV.y);
	COLOR = vec4(COLOR.rgb, alpha);
}