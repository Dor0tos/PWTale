extends Node

@onready var world : CanvasLayer = $World
@onready var player = $World/Gneg

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_pos.size() <= 1:
		return
	else:
		player.position = Global.player_pos.pop_front()


func _on_area_2d_body_entered(body):
	SceneTransition.change_scene(player, "res://Scenes/donut_room.tscn", Vector2(0, 25))


func _on_area_2d_2_body_entered(body):
	SceneTransition.change_scene(player, "res://Scenes/bedrock_room.tscn", Vector2(0, 25))
