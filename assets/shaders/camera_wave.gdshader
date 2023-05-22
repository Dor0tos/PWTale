shader_type canvas_item;

void fragment(){
	float offset = UV.y * UV.y * UV.y ;
	vec2 uv_def = vec2(UV.x + 0.025 * (UV.y / 2.0) * sin(TIME * 2.5 + UV.y * UV.y * 50.0), UV.y);
	COLOR = texture(TEXTURE, uv_def);
}