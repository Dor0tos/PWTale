extends Control

@export var soul_color : Color = Color.RED

@onready var selected_id = 0
@onready var page_id = 0
@onready var page_count = 0
@onready var page_no = $Panel/MarginContainer/Panel/MarginContainer/PageNo
@onready var sound_player = $AudioStreamPlayer
@onready var move_sound = preload("res://assets/sounds/snd_squeak.wav")
@onready var select_sound = preload("res://assets/sounds/snd_select.wav")
@onready var options = [
	$"Panel/MarginContainer/Panel/MarginContainer/HBoxContainer2/Control/VBoxContainer/Variant 0",
	$"Panel/MarginContainer/Panel/MarginContainer/HBoxContainer2/Control/VBoxContainer/Variant 1",
	$"Panel/MarginContainer/Panel/MarginContainer/HBoxContainer2/Control2/VBoxContainer/Variant 2",
	$"Panel/MarginContainer/Panel/MarginContainer/HBoxContainer2/Control2/VBoxContainer/Variant 3",
]
@onready var options_matrix : Array = [[], []]
@onready var current_pos : Vector2 = Vector2.ZERO

func activate(value):
	_set_options(value)
	set_process_input(true)
	for i in range(4):
		current_pos = Vector2(i / 2, i % 2)
		change_selection(false)
	current_pos = Vector2.ZERO
	visible = true

func deactivate():
	visible = false
	_set_options([])
	draw_page()
	set_process_input(false)

func _set_options(value):
	options_matrix = [[], []]
	var y = 0
	var helper : Dictionary
	for i in range(value.size()):
		options_matrix[y].append(value[i])
		y = (y + 1) % 2
	page_count = ceil(options_matrix[0].size() / 2.0)

func draw_page():
	for x in range(2):
		for y in range(2):
			var option_id = 2 * x + y
			options[option_id].visible = false
			var id = int(current_pos.x / 2.0)
			if (id * 2 + x) < options_matrix[y].size():
				options[option_id].get_node("Name").text = options_matrix[y][id * 2 + x]["Name"]
				options[option_id].visible = true
	
	page_no.visible = page_count > 1
	if page_count > 1:
		draw_page_number()

func change_selection(state):
	var id = int(current_pos.x * 2 + current_pos.y) % 4
	options[id].get_node("TextureRect").modulate = Color.RED # Place Battle-Based soul color
	options[id].get_node("TextureRect").visible = state
	options[id].get_node("TextDeco").visible = !state

func draw_page_number():
	page_no.text = "Стр %d/%d" % [current_pos.x / 2 + 1, page_count]

func _ready():
	set_process_input(false)
	page_count = ceil(options_matrix[0].size() / 2.0)
	draw_page()

func is_enters_interval(value, min, max) -> bool:
	return value <= max and value >= min

func is_element_exists(array : Array, element_id : Vector2) -> bool:
	if !is_enters_interval(element_id.y, 0, array.size() - 1):
		return false
	
	if !is_enters_interval(element_id.x, 0, array[element_id.y].size() - 1):
		return false
	
	return true

func is_enters_new_page(old_id : Vector2, new_id : Vector2) -> bool:
	var current_page = int(old_id.x / 2)
	var next_page = int(new_id.x / 2)
	
	return current_page != next_page

func play_select_sound():
	sound_player.stream = select_sound
	sound_player.play()

func play_move_sound():
	sound_player.stream = move_sound
	sound_player.play()

func calc_new_pos(offset):
	var new_pos = Vector2.ZERO
	new_pos.x = current_pos.x + offset.x
	new_pos.y = current_pos.y + offset.y
	
	if !is_element_exists(options_matrix, new_pos):
		if is_enters_new_page(current_pos, new_pos) and (new_pos.x / 2 < options_matrix[new_pos.y].size() / 2):
			new_pos.y = 0
			play_move_sound()
		else:
			return
	
	current_pos = new_pos
	play_move_sound()

func _input(event):
	change_selection(false)
	
	if Input.is_action_just_pressed("ui_right"):
		calc_new_pos(Vector2(1, 0))
	if Input.is_action_just_pressed("ui_left"):
		calc_new_pos(Vector2(-1, 0))
	if Input.is_action_just_pressed("ui_up"):
		calc_new_pos(Vector2(0, -1))
	if Input.is_action_just_pressed("ui_down"):
		calc_new_pos(Vector2(0, 1))
	
	if Input.is_action_just_pressed("ui_accept"):
		play_select_sound()
		if options_matrix[0].size() != 0:
			options_matrix[current_pos.y][current_pos.x]["Action"].call(
				options_matrix[current_pos.y][current_pos.x]["Data"]
			)
	
	draw_page()
	change_selection(true)
