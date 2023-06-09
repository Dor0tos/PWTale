extends Control

func _ready():
	$SkipControl/VBoxContainer/ProgressBar.max_value = $Timer.wait_time
	
	$AnimationPlayer.play("Appear")
	await $AnimationPlayer.animation_finished
	SceneTransition.ui_transition("res://Scenes/base_scene.tscn")

func _process(_delta):
	if !$Timer.is_stopped() and !timeout:
		$SkipControl/VBoxContainer/ProgressBar.value = $Timer.wait_time - $Timer.time_left

func _input(event):
	if event.is_action_pressed("ui_cancel") and !timeout:
		$Timer.start()
		create_tween().tween_property(
			$SkipControl,
			"modulate",
			Color.WHITE,
			0.5
		)
	elif event.is_action_released("ui_cancel") or timeout:
		$Timer.stop()
		create_tween().tween_property(
			$SkipControl,
			"modulate",
			Color.TRANSPARENT,
			0.5
		)

@onready var timeout = false
func _on_timer_timeout():
	timeout = true
	var tween = create_tween()
	tween.parallel().tween_property(
		$Music,
		"volume_db",
		-20,
		0.5
	)
	tween.parallel().tween_property(
		$CenterContainer/VBoxContainer/TextWindow/AudioStreamPlayer,
		"volume_db",
		-20,
		0.5
	)
	SceneTransition.ui_transition("res://Scenes/base_scene.tscn")
