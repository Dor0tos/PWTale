extends Control

@export var player : CharacterBody2D

func _process(delta):
	$Label.text = "x: " + str(player.velocity.x)
	$Label2.text = "y: " + str(player.velocity.y)
	
	$ColorRect2.position = Vector2(
		player.velocity.x / 175 * 20 + 20 - 1,
		player.velocity.y / 175 * 20 + 20 - 1
	)
