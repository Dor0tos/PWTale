extends Node

@onready var text_box = $TextWindow/MarginContainer/Panel/MarginContainer/HBoxContainer/MarginContainer/Text
@onready var portrait = $TextWindow/MarginContainer/Panel/MarginContainer/HBoxContainer/Portrait
@onready var sound_player = $AudioStreamPlayer
@onready var run_mode = RunMode.STILL

signal text_shown
signal finished
signal reading_ended

var portrait_picture = "" : set = set_portrait_picture

enum State {
	READY,
	READING,
	FINISHED
}

enum RunMode {
	STILL,
	FIGHT
}

var current_state : State = State.READY
var text_queue = []

func _ready():
	pass
	#set_portrait_picture("res://assets/PWGood_portrait.png")
	#add_text("Очень длинный текст жесть просто какой длинный, аж на 2 строки разросся, а нет уже на 3")
	#add_text("Строка 2")
	#add_text("Строка 3")
	#show_textbox()

func reset_text():
	text_queue = []

func add_text(text):
	text_queue.push_back(text)

func run_reading(text: String):
	text_box.visible_ratio = 0
	text_box.text = text
	$Timer.start()

func _input(event):
	match current_state:
		State.READY:
			pass
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				text_box.visible_ratio = 1.0
				on_text_shown()
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				if text_queue.is_empty():
					emit_signal("text_shown")
					hide_textbox()
					change_state(State.READY)
				else:
					run_reading(text_queue.pop_front())
					change_state(State.READING)

func show_textbox():
	if run_mode != RunMode.FIGHT:
		get_tree().paused = true
	self.visible = true
	set_process_input(true)
	run_reading(text_queue.pop_front())
	change_state(State.READING)

func hide_textbox():
	if run_mode != RunMode.FIGHT:
		get_tree().paused = false
	self.visible = false
	set_process_input(false)
	text_box.text = ""
	text_box.visible_characters = 0
	emit_signal("reading_ended")

func change_state(new_state : State):
	current_state = new_state

func on_text_shown():
	$Timer.stop()
	change_state(State.FINISHED)

func set_portrait_picture(value : String):
	portrait.texture = load(value)
	portrait.visible = true

func strip_bbcode() -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(text_box.text, "", true)

func _on_timer_timeout():
	if text_box.visible_characters == strip_bbcode().length():
		on_text_shown()
	text_box.visible_characters += 1
	$AudioStreamPlayer.play(0.02)
	
