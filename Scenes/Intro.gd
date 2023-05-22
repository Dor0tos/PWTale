extends Control

func _ready():
	$AnimationPlayer.play("Appear")
	await $AnimationPlayer.animation_finished
	SceneTransition.ui_transition("res://Scenes/base_scene.tscn")
