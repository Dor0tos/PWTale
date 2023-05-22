extends Control

@onready var first_sound = preload("res://assets/sounds/snd_break1.wav")
@onready var second_sound = preload("res://assets/sounds/snd_break2.wav")

@onready var buttons = [
	$Panel/VBoxContainer/Button_TryAgain,
	$Panel/VBoxContainer/Button_Exit
]

@onready var selected = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process_input(false)
	$AnimationPlayer.play("RESET")
	$Soul.position = Global.soul_position
	buttons[0].select()
	
	var tween = create_tween()
	
	for i in range(20):
		$Soul/Sprite2D.position = Vector2(randf(), randf()) * 2.5
		await get_tree().create_timer(0.05).timeout
	
	$Soul/Sprite2D.frame = 1
	$AudioPlayer.stream = first_sound
	$AudioPlayer.play()
	await get_tree().create_timer(1).timeout
	
	$Soul/Sprite2D.visible = false
	$AudioPlayer.stream = second_sound
	$AudioPlayer.play()
	$Soul/Soul_particles.emitting = true
	await get_tree().create_timer(1).timeout
	
	$AnimationPlayer.play("appear")
	set_process_input(true)

func play_song():
	$MusicPlayer.play()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if event.keycode == KEY_UP or event.keycode == KEY_W:
			buttons[selected].deselect()
			selected = 1 if selected - 1 < 0 else selected - 1
			buttons[selected].select()
		elif event.keycode == KEY_DOWN or event.keycode == KEY_S:
			buttons[selected].deselect()
			selected = 0 if selected + 1 > 1 else selected + 1
			buttons[selected].select()
		elif event.keycode == KEY_ENTER:
			$SoundPlayer.play()
			$MusicPlayer.stop()
			if selected == 1:
				SceneTransition.ui_transition("res://Scenes/MainMenu.tscn")
			elif selected == 0:
				Global.Inventory = Global.Pre_Battle_Inventory
				SceneTransition.fall_in_battle(Vector2(
					ProjectSettings.get_setting("display/window/size/viewport_width"),
					ProjectSettings.get_setting("display/window/size/viewport_height")
				) / 2.0)
