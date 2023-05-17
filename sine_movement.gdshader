shader_type canvas_item;

uniform float period : hint_range(0.5, 5.0, 0.1);
uniform float amplitude : hint_range(0, 50, 1);
uniform float phase_offset : hint_range(0.0, 360.0, 0.01);

void vertex() {
	VERTEX += vec2(0, amplitude * sin(TIME * PI / period + phase_offset * PI / 180.0));
}
