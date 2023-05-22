shader_type canvas_item;

void fragment() {
	if (pow(UV.x - 0.5, 2.0) + pow(UV.y - 0.5, 2.0) + 0.09 <= 0.25){
		COLOR.a = 0.0;
	}
}
