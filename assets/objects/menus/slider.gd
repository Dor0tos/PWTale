extends Control

@onready var text = $Text
@onready var select_panel = $Text/MarginContainer/ColorRect
@onready var slider = $HSlider

@export var texture : CompressedTexture2D = preload("res://assets/sprites/menus/start_game.png")
@onready var selected = false
signal value_changed(value)

func _ready():
	text.texture = texture
	text.size = text.texture.get_size()

func set_value(val):
	slider.value = int(val * 100)

func _input(event):
	if event.is_action_released("ui_right") or event.is_action_released("ui_left"):
		if selected:
			emit_signal("value_changed", slider.value)

func focus_slider():
	slider.grab_focus()

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
	slider.grab_focus()

func deselect():
	var tween = create_tween()
	tween.tween_property(
		select_panel,
		"size",
		Vector2(0, text.texture.get_size().y + 2),
		0.1
	)
	selected = false
	slider.release_focus()
