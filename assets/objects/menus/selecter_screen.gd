extends Control

@onready var fullscreen_text = preload("res://assets/sprites/menus/fullscreen.png")
@onready var windowed_text = preload("res://assets/sprites/menus/windowed.png")
@onready var broderless_text = preload("res://assets/sprites/menus/borderless_fullscreen.png")

@onready var fullscreen_text_ns = preload("res://assets/sprites/menus/fullscreen_ns.png")
@onready var windowed_text_ns = preload("res://assets/sprites/menus/windowed_ns.png")
@onready var broderless_text_ns = preload("res://assets/sprites/menus/borderless_fullscreen_ns.png")

@onready var text = $GridContainer/Control/Text
@onready var mode = $GridContainer/DisplayMode
@onready var select_panel = $GridContainer/Control/Text/MarginContainer/ColorRect
@onready var selectors = [
	$GridContainer/Control/Selecters_Container/Selecter2,
	$GridContainer/Control/Selecters_Container/Selecter3,
	$GridContainer/Control/Selecters_Container/Selecter4,
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
			set_value(clamp(level + 1, 0, 2))
			$AudioPlayer.play()
			emit_signal("value_changed", level)
		elif event.is_action_pressed("ui_left"):
			set_value(clamp(level - 1, 0, 2))
			$AudioPlayer.play()
			emit_signal("value_changed", level)

func set_value(val : int):
	level = val
	for selector in selectors:
		if selected:
			selector.frame = 1
		else:
			selector.frame = 0
	
	selectors[val].frame = 3 if selected else 2
	
	if val == 0:
		mode.texture = windowed_text if selected else windowed_text_ns
	elif val == 1:
		mode.texture = broderless_text if selected else broderless_text_ns
	elif val == 2:
		mode.texture = fullscreen_text if selected else fullscreen_text_ns

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
