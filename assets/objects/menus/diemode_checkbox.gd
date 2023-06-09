extends Control

@onready var text = $Text
@onready var select_panel = $Text/MarginContainer/ColorRect
@onready var check_box = $Selecters_Container/Selecter4

@export var texture : CompressedTexture2D = preload("res://assets/sprites/menus/start_game.png")
@onready var selected = false
@onready var checked = false
signal value_changed(value)

func _ready():
	text.texture = texture
	text.size = text.texture.get_size()

func _input(event):
	if selected:
		if event.is_action_pressed("ui_accept"):
			set_value(!checked)
			$AudioPlayer.play()
			emit_signal("value_changed", checked)

func set_value(val : bool):
	checked = val
	
	check_box.frame = 2 if checked else 0
	check_box.frame += 1 if selected else 0

func select():
	var tween = create_tween()
	$AudioPlayer.play()
	tween.tween_property(
		select_panel,
		"size",
		text.texture.get_size() + Vector2.ONE * 2,
		0.1
	)
	selected = true
	set_value(checked)

func deselect():
	var tween = create_tween()
	tween.tween_property(
		select_panel,
		"size",
		Vector2(0, text.texture.get_size().y + 2),
		0.1
	)
	selected = false
	set_value(checked)
