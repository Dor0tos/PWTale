extends Control

@onready var label = $MarginContainer/Panel/MarginContainer2/Control/RichTextLabel
@onready var icon_rect = $MarginContainer/Panel/MarginContainer/TextureRect
@onready var back_panel = $MarginContainer/Panel
@onready var sound_player : AudioStreamPlayer = $"../../../../../SoundPlayer"

@onready var default_soul = preload("res://assets/sprites/soul.png")
@onready var geo_soul = preload("res://assets/sprites/soul_geo.png")

@export var soul_texture : int = 0

@onready var snd_select = preload("res://assets/sounds/snd_squeak.wav")
@onready var snd_press = preload("res://assets/sounds/snd_select.wav")

@onready var default_color = Global.Color_rgba(250, 106, 10)
@onready var highlight_color = Global.Color_rgba(255, 213, 65)

@export var text : String = "Кнопка" 
@export var icon : Texture2D
@export var is_selected : bool = false
@export var soul_color : Color = Color.RED

signal button_pressed(sender)

func get_soul_tecture():
	if soul_texture == 1:
		return geo_soul
	else:
		return default_soul

func change_selection_status(selected : bool):
	is_selected = selected
	
	if is_selected:
		sound_player.stream = snd_select
		sound_player.play()
	
	icon_rect.texture = icon if !selected else get_soul_tecture()
	back_panel.get_theme_stylebox("panel").border_color = Color.YELLOW if selected else default_color
	icon_rect.modulate = soul_color if selected else Color.WHITE
	label.set(
		"theme_override_colors/default_color",Color.YELLOW if selected else default_color
	)

func _ready():
	label.text = "[right]{txt}[/right]".format({"txt": text})
	icon_rect.texture = icon

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and is_selected:
		emit_signal("button_pressed", self)
		sound_player.stream = snd_press
		sound_player.play()
