extends Node

@onready var world : CanvasLayer = $World
@onready var player = $World/Gneg

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_pos.size() > 1:
		player.position = Global.player_pos.pop_front()
	$"Triggers/Bedrock Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/bedrock_room.tscn")
	)

func _on_bedrock_room_entry(body, new_scene):
	print("Hello")
	SceneTransition.change_scene(player, "res://Scenes/bedrock_room.tscn", Vector2(0, 25))

func _on_room_entry_body_entered(_body, new_scene):
	print("Hello")
	SceneTransition.change_scene(player, new_scene, Vector2(0, 25))


func _on_pw_good_encounter_battle_begin():
	SceneTransition.fall_in_battle(player.get_global_transform_with_canvas().origin)


func _on_last_envc_activate_body_entered(body):
	if body != player:
		return
	
	$World/Last_envc_activate.queue_free()
	$World/PWGood_last_encounter.enabled = true
	$World/PWGood_last_encounter.switch()
