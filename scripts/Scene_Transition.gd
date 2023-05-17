extends CanvasLayer

func change_scene(player, path : String, _offset : Vector2 = Vector2.ZERO) -> void:
	$AnimationPlayer.play("disolve")
	await $AnimationPlayer.animation_finished
	
	Global.travel_to(player, path, _offset)
	$AnimationPlayer.play_backwards("disolve")
