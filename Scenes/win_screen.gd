extends Control

func _input(event):
	if event.is_action_pressed("ui_accept"):
		$AnimationPlayer.play("thanks")
		await $AnimationPlayer.animation_finished
		SceneTransition.fall_in_final()
