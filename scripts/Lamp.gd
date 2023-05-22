extends Sprite2D

const dialoge = preload("res://assets/text_window.tscn")

@export var shown_text : PackedStringArray

var is_player_nearby : bool = false
var lamp_on : bool = false

signal state_changed

func _ready():
	var area : Area2D
	for node in get_children():
		if node is Area2D:
			area = node
			break
	area.connect("body_entered", _on_area_2d_body_entered)
	area.connect("body_exited", _on_area_2d_body_exited)

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and is_player_nearby:
		lamp_on = !lamp_on
		frame = lamp_on
		emit_signal("state_changed")


func _on_area_2d_body_entered(body):
	if body.name != "Gneg":
		return
	is_player_nearby = true


func _on_area_2d_body_exited(body):
	if body.name != "Gneg":
		return
	is_player_nearby = false
