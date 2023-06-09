extends CanvasLayer

@export var VolumeCurve : Curve

@onready var settings = [
	$UI/Panel/VBoxContainer/Master,
	$UI/Panel/VBoxContainer/Effects,
	$UI/Panel/VBoxContainer/Music,
	$UI/Panel/VBoxContainer/Selecter2,
	$UI/Panel/VBoxContainer/Button_Back,
	$UI/Panel/VBoxContainer/Button_Menu
]

@onready var selected_setting = 0
@onready var screen_mode_saved = true

func _ready():
	settings[0].select()
	
	for i in range(3):
		settings[i].set_value(Global.Volume_settings[i])
	
	$UI/Panel/VBoxContainer/Selecter.set_valuef(Global.Start_Difficulty)
	
	settings[3].set_value(Global.screen_mode)

func selection_changed():
	$UI/MasterTester.stop()
	$UI/SoundTester.stop()
	$UI/MusicTester.stop()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_UP or event.keycode == KEY_W:
			if selected_setting == 3 and !screen_mode_saved:
				settings[selected_setting].set_value(Global.screen_mode)
				screen_mode_saved = true
			
			settings[selected_setting].deselect()
			selected_setting = 5 if selected_setting - 1 < 0 else selected_setting - 1
			settings[selected_setting].select()
			
			if selected_setting == 3:
				screen_mode_saved = false
			selection_changed()
		elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
			if selected_setting == 3 and !screen_mode_saved:
				settings[selected_setting].set_value(Global.screen_mode)
				screen_mode_saved = true
			
			settings[selected_setting].deselect()
			selected_setting = 0 if selected_setting + 1 > 5 else selected_setting + 1
			settings[selected_setting].select()
			selection_changed()
			
			if selected_setting == 3:
				screen_mode_saved = false
		elif event.keycode == KEY_ENTER:
			$UI/SoundPlayer.play()
			if selected_setting == 3:
				screen_mode_saved = true
				Global.set_screen_mode(settings[selected_setting].level)
			elif selected_setting == 4:
				Global.save_data()
				SceneTransition.pause_off(get_tree().get_root())
			elif selected_setting == 5:
				Global.save_data()
				AudioServer.set_bus_effect_enabled(
					AudioServer.get_bus_index("Music"), 0, false
				)
				SceneTransition.ui_transition("res://Scenes/MainMenu.tscn")
		elif event.keycode == KEY_ESCAPE:
			$UI/SoundPlayer.play()
			Global.save_data()
			SceneTransition.pause_off(get_tree().get_root())

func percentage_to_db(perc: float):
	return VolumeCurve.sample(perc) * -80.0

func _on_slider_value_changed(value, setting):
	if setting == "Master":
		Global.Volume_settings[0] = float(value) / 100;
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Master"),
			percentage_to_db(Global.Volume_settings[0])
		)
	elif setting == "Effects":
		Global.Volume_settings[1] = float(value) / 100;
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Effects"),
			percentage_to_db(Global.Volume_settings[1])
		)
	elif setting == "Music":
		Global.Volume_settings[2] = float(value) / 100;
		AudioServer.set_bus_volume_db(
			AudioServer.get_bus_index("Music"),
			percentage_to_db(Global.Volume_settings[2])
		)

func _on_selecter_value_changed(value):
	if value == 0:
		Global.Start_Difficulty = 0.0
	elif value == 1:
		Global.Start_Difficulty = 0.25
	elif value == 2:
		Global.Start_Difficulty = 0.50
	elif value == 3:
		Global.Start_Difficulty = 0.75
