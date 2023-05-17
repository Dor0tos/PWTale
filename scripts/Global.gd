extends Node

var player_pos : Array = []
var soul_position = Vector2.ZERO

func travel_to(player, path : String, offset : Vector2 = Vector2.ZERO):
	if player != null:
		player_pos.push_back(player.position + offset)
	get_tree().change_scene_to_file(path)

func Color_rgba(r: float, g: float, b: float, a: float = 255.) -> Color:
	return Color(r / 255., g / 255., b / 255., a / 255.)

func set_focus(node, state):
	node.set_process_input(state)
