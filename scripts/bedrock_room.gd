extends CanvasLayer

@onready var player = $World/Gneg

func _ready():
	if Global.player_pos.size() <= 1:
		return
	else:
		player.position = Global.player_pos.pop_front()

func _on_area_2d_body_entered(body):
	SceneTransition.change_scene(player, "res://Scenes/base_scene.tscn", Vector2(0, -30))
