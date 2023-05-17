extends Node2D

@onready var is_shooting : bool = false

signal arrow_shooted

func _ready():
	$AnimationPlayer.play("appear")

func shoot():
	if is_shooting:
		return
	
	is_shooting = true
	$AnimationPlayer.play("shoot")
	await $AnimationPlayer.animation_finished
	is_shooting = false

func shoot_nonstop():
	$AnimationPlayer.play("shoot")

func shooted():
	emit_signal("arrow_shooted")
