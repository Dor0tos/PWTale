extends Control

@onready var options = [
	$Panel/VFlowContainer/VBoxContainer/GridContainer/CenterContainer/Button_Graphics,
	$Panel/VFlowContainer/VBoxContainer/GridContainer/CenterContainer2/Button_Music,
	$Panel/VFlowContainer/VBoxContainer/GridContainer/CenterContainer3/Button_Sounds,
	$Panel/VFlowContainer/VBoxContainer/GridContainer/CenterContainer4/Button_Back
]

@onready var tabs = [
	$Panel/VFlowContainer/Graphics,
	$Panel/VFlowContainer/Music,
	$Panel/VFlowContainer/Sounds
]

@onready var selected_option = 0

func _ready():
	options[selected_option].select()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_LEFT or event.keycode == KEY_A:
			options[selected_option].deselect()
			selected_option = 3 if selected_option - 1 < 0 else selected_option - 1
			options[selected_option].select()
		elif event.keycode == KEY_RIGHT or event.keycode == KEY_D:
			options[selected_option].deselect()
			selected_option = 0 if selected_option + 1 > 3 else selected_option + 1
			options[selected_option].select()
		elif event.keycode == KEY_ENTER:
			$SoundPlayer.play()
			if selected_option == 3:
				SceneTransition.ui_transition("res://Scenes/MainMenu.tscn")
		
		for tab in tabs:
			tab.visible = false
		
		if selected_option != 3:
			tabs[selected_option].visible = true
