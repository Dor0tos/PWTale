extends Node2D



func _ready():
	$AnimationPlayer.play("RESET")
	await $AnimationPlayer.animation_finished
	queue_free()
