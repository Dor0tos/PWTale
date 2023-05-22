extends Node2D

const dialoge = preload("res://assets/text_window.tscn")

@export var shown_text : PackedStringArray

var is_player_nearby : bool = false

func _ready():
	var area : Area2D
	for node in get_children():
		if node is Area2D:
			area = node
			break
	area.connect("body_entered", _on_area_2d_body_entered)
	area.connect("body_exited", _on_area_2d_body_exited)

func _input(_event):
	if Input.is_action_just_pressed("ui_accept") and is_player_nearby:
		await get_tree().create_timer(0.01).timeout
		var tw = dialoge.instantiate()
		
		for s in shown_text:
			tw.add_text(s)
		get_tree().current_scene.add_child(tw)
		
		tw.show_textbox()
		set_process_input(false)
		await tw.reading_ended
		set_process_input(true)


func _on_area_2d_body_entered(body):
	if body.name != "Gneg":
		return
	is_player_nearby = true


func _on_area_2d_body_exited(body):
	if body.name != "Gneg":
		return
	is_player_nearby = false
