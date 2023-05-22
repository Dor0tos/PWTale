extends Control

@export var tell_sound = preload("res://assets/sounds/SND_TXT1.wav")

@onready var text_box = $MarginContainer/Panel/MarginContainer/HBoxContainer/MarginContainer/Text
@onready var sound_player = $AudioStreamPlayer
@onready var run_mode = RunMode.STILL

signal text_shown
signal finished
signal reading_ended

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

func set_new_sound(sound):
	sound_player.stream = sound

func _ready():
	sound_player.stream = tell_sound

func text_show(text : String):
	add_text(text)
	show_textbox()

func reset_text():
	text_box.text = ""
	text_queue = []

func add_text(text):
	text_queue.push_back(text)

func run_reading(text: String):
	text_box.visible_ratio = 0
	text_box.text = text
	$Timer.start()

func show_textbox():
	self.visible = true
	run_reading(text_queue.pop_front())
	change_state(State.READING)

func hide_textbox():
	self.visible = false
	text_box.text = ""
	text_box.visible_characters = 0
	emit_signal("reading_ended")

func change_state(new_state : State):
	current_state = new_state

func on_text_shown():
	$Timer.stop()
	change_state(State.FINISHED)

func strip_bbcode() -> String:
	var regex = RegEx.new()
	regex.compile("\\[.+?\\]")
	return regex.sub(text_box.text, "", true)

func _on_timer_timeout():
	if text_box.visible_characters == strip_bbcode().length():
		on_text_shown()
	text_box.visible_characters += 1
	$AudioStreamPlayer.play(0.02)
	
