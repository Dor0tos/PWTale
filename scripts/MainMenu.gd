extends Control

@onready var VolumeCurve = preload("res://Scenes/Volume_Curve.tres")
@onready var buttons = [
	$Panel/VBoxContainer/Button_Begin,
	$Panel/VBoxContainer/Button_BeginBattle,
	$Panel/VBoxContainer/Button_Settings,
	$Panel/VBoxContainer/Button_Content,
	$Panel/VBoxContainer/Button_exit
]

@onready var selected_button = 0

func percentage_to_db(perc: float):
	return VolumeCurve.sample(perc) * -80.0

func _ready():
	buttons[selected_button].select()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_UP or event.keycode == KEY_W:
			buttons[selected_button].deselect()
			selected_button = 4 if selected_button - 1 < 0 else selected_button - 1
			buttons[selected_button].select()
		elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
			buttons[selected_button].deselect()
			selected_button = 0 if selected_button + 1 > 4 else selected_button + 1
			buttons[selected_button].select()
		elif event.keycode == KEY_ENTER:
			$AudioPlayer.play()
			if selected_button == 0:
				SceneTransition.ui_transition("res://Scenes/Intro.tscn")
			if selected_button == 1:
				SceneTransition.fall_in_battle(Vector2(
					ProjectSettings.get_setting("display/window/size/viewport_width"),
					ProjectSettings.get_setting("display/window/size/viewport_height")
				) / 2.0)
			elif selected_button == 2:
				SceneTransition.ui_transition("res://Scenes/settings_screen.tscn")
			elif selected_button == 3:
				SceneTransition.ui_transition("res://Scenes/content.tscn")
			elif selected_button == 4:
				get_tree().quit()
