extends Control

@onready var text = $Text
@onready var select_panel = $Text/MarginContainer/ColorRect
@onready var selectors = [
	$Selecters_Container/Selecter,
	$Selecters_Container/Selecter2,
	$Selecters_Container/Selecter3,
	$Selecters_Container/Selecter4,
]

@export var texture : CompressedTexture2D = preload("res://assets/sprites/menus/start_game.png")
@onready var selected = false
@onready var level = 0
signal value_changed(value)

func _ready():
	text.texture = texture
	text.size = text.texture.get_size()
	set_value(1)

func _input(event):
	if selected:
		if event.is_action_pressed("ui_right"):
			set_value(clamp(level + 1, 0, 3))
			$AudioPlayer.play()
			emit_signal("value_changed", level)
		elif event.is_action_pressed("ui_left"):
			set_value(clamp(level - 1, 0, 3))
			$AudioPlayer.play()
			emit_signal("value_changed", level)

func set_valuef(val : float):
	if val < 0.25:
		set_value(0)
	elif val < 0.5:
		set_value(1)
	elif val < 0.75:
		set_value(2)
	else:
		set_value(3)

func set_value(val : int):
	level = val
	for selector in selectors:
		if selected:
			selector.frame = 1
		else:
			selector.frame = 0
	
	selectors[val].frame = 3 if selected else 2

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
	set_value(level)

func deselect():
	var tween = create_tween()
	tween.tween_property(
		select_panel,
		"size",
		Vector2(0, text.texture.get_size().y + 2),
		0.1
	)
	selected = false
	set_value(level)
