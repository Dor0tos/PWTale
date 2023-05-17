extends Node2D

func _ready():
	$AnimationPlayer.play("Appear")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("shoot")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("Disappear")
	await $AnimationPlayer.animation_finished
	queue_free()
