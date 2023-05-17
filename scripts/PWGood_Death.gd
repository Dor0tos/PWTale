extends Node2D

signal pwgood_died

func die():
	visible = true
	$AnimationPlayer.play("death")
	await $AnimationPlayer.animation_finished
	visible = false
	emit_signal("pwgood_died")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
