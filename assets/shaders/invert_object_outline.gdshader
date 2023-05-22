shader_type canvas_item;

void vertex(){
	VERTEX.x += sin(5.0 * TIME + UV.y * 10.0) * 1.0;
}