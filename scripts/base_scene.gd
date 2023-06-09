extends Node

@onready var world : CanvasLayer = $World
@onready var player = $World/Gneg

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player_pos.size() > 1:
		player.position = Global.player_pos.pop_front()
	
	$"World/Bedrock Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/bedrock_room.tscn")
	)
	$"World/Donut Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/donut_room.tscn")
	)
	$"World/Plants Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/plants_room.tscn")
	)
	$"World/Reverce Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/reverce_room.tscn")
	)
	$"World/Cubes Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/cubes_room.tscn")
	)
	$"World/Experiment Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/experiment_room.tscn")
	)
	$"World/Wardrobe Room Entry".body_entered.connect(
		_on_room_entry_body_entered.bind("res://Scenes/garderob_room.tscn")
	)
	
	for i in range(interactive_objs.size()):
		if i < 3:
			interactive_objs[i].pwgood_appear.connect(
				interactive_state_changed.bind(i)
			)
		else:
			interactive_objs[i].items_held.connect(
				interactive_state_changed.bind(i)
			)
	
	load_interactive_states()

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

@onready var interactive_objs = [
	$World/PWGood_encounter1,
	$World/PWGood_encounter2,
	$World/PWGood_last_encounter,
	
	$World/Chest,
	$World/Chest4,
	$World/Chest5
]

func interactive_state_changed(id : int):
	Global.interactive_states[id] = false

func load_interactive_states():
	for i in range(interactive_objs.size()):
		if i < 3 and !Global.interactive_states[i]:
			interactive_objs[i].queue_free()
		elif i >= 3 and !Global.interactive_states[i]:
			interactive_objs[i].Amount = 0
			interactive_objs[i].shown_text = ["Этот сундук пуст"]
