extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func _input(event):
	if event is InputEventKey:
		print(event.keycode)
		if event.keycode == KEY_ESCAPE:
			get_tree().paused = !get_tree().paused
