extends Node2D

@onready var player : AnimationPlayer = $AnimationPlayer

var start_delay : float = 1.0
var detonation_delay : float = 1.5

func init(start_d, deton_d):
	start_delay = start_d
	detonation_delay = deton_d

func _ready():
	player.play("RESET")
	await get_tree().create_timer(start_delay).timeout
	player.play("Appear")
	await player.animation_finished
	await get_tree().create_timer(detonation_delay).timeout
	player.play("Detonate")
	await player.animation_finished
	player.play("Explode")
	await player.animation_finished
	queue_free()
