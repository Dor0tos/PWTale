extends Control

@export var VolumeCurve : Curve

@onready var settings = [
	$Panel/VBoxContainer/Master,
	$Panel/VBoxContainer/Effects,
	$Panel/VBoxContainer/Music,
	$Panel/VBoxContainer/Selecter,
	$Panel/VBoxContainer/Selecter3,
	$Panel/VBoxContainer/Selecter2,
	$Panel/VBoxContainer/Button_Back
]

@onready var selected_setting = 0
@onready var screen_mode_saved = true

func _ready():
	settings[0].select()
	
	for i in range(3):
		settings[i].set_value(Global.Volume_settings[i])
	
	settings[3].set_valuef(Global.Start_Difficulty)
	
	settings[4].set_value(Global.one_hit_mode)
	settings[5].set_value(Global.screen_mode)

func selection_changed():
	$MasterTester.stop()
	$SoundTester.stop()
	$MusicTester.stop()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_UP or event.keycode == KEY_W:
			if selected_setting == 5 and !screen_mode_saved:
				settings[selected_setting].set_value(Global.screen_mode)
				screen_mode_saved = true
			
			settings[selected_setting].deselect()
			selected_setting = 6 if selected_setting - 1 < 0 else selected_setting - 1
			settings[selected_setting].select()
			
			if selected_setting == 5:
				screen_mode_saved = false
			selection_changed()
		elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
			if selected_setting == 5 and !screen_mode_saved:
				settings[selected_setting].set_value(Global.screen_mode)
				screen_mode_saved = true
			
			settings[selected_setting].deselect()
			selected_setting = 0 if selected_setting + 1 > 6 else selected_setting + 1
			settings[selected_setting].select()
			selection_changed()
			
			if selected_setting == 5:
				screen_mode_saved = false
		elif event.keycode == KEY_ENTER:
			$SoundPlayer.play()
			if selected_setting == 5:
				screen_mode_saved = true
				Global.set_screen_mode(settings[selected_setting].level)
			elif selected_setting == 6:
				Global.save_data()
				SceneTransition.ui_transition("res://Scenes/MainMenu.tscn")

func percentage_to_db(perc: float):
	return VolumeCurve.sample(perc) * -80.0

func _on_slider_value_changed(value, setting):
	if setting == "Master":
		$MasterTester.play()
		Global.Volume_settings[0] = float(value) / 100;
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			percentage_to_db(Global.Volume_settings[0])
		)
	elif setting == "Effects":
		$SoundTester.play()
		Global.Volume_settings[1] = float(value) / 100;
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Effects"),
			percentage_to_db(Global.Volume_settings[1])
		)
	elif setting == "Music":
		$MusicTester.play()
		Global.Volume_settings[2] = float(value) / 100;
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Music"),
			percentage_to_db(Global.Volume_settings[2])
		)

func _on_selecter_value_changed(value):
	Global.Difficulty_Mode = value
	if value == 0:
		Global.Start_Difficulty = 0.0
	elif value == 1:
		Global.Start_Difficulty = 0.25
	elif value == 2:
		Global.Start_Difficulty = 0.50
	elif value == 3:
		Global.Start_Difficulty = 0.75


func _on_diemode_value_changed(value):
	Global.one_hit_mode = value
