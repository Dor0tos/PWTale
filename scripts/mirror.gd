extends Node2D

@export var Real_Gneg : CharacterBody2D
@onready var gneg_mirrored = $SubViewport/Gneg_mirrored
const otherside_center = Vector2(8, 18)

const SPEED = 100.0

var is_reading = false

func _physics_process(delta):
	var direction_x = 0
	var direction_y = 0
	if !is_reading:
		direction_x = Input.get_axis("ui_left", "ui_right")
		direction_y = -Input.get_axis("ui_up", "ui_down")
	
	if direction_x:
		gneg_mirrored.velocity.x = direction_x * SPEED
	else:
		gneg_mirrored.velocity.x = 0
	
	if direction_y:
		gneg_mirrored.velocity.y = direction_y * SPEED
	else:
		gneg_mirrored.velocity.y = 0
	gneg_mirrored.velocity = gneg_mirrored.velocity.normalized()
	
	if gneg_mirrored.velocity != Vector2.ZERO:
		$SubViewport/Gneg_mirrored/AnimationTree.get("parameters/playback").travel("Walk")
		$SubViewport/Gneg_mirrored/AnimationTree.set("parameters/Idle/blend_position", gneg_mirrored.velocity)
		$SubViewport/Gneg_mirrored/AnimationTree.set("parameters/Walk/blend_position", gneg_mirrored.velocity)
	else:
		$SubViewport/Gneg_mirrored/AnimationTree.get("parameters/playback").travel("Idle")
	
	var dir_to_player = Real_Gneg.global_position - $Position2D.global_position
	dir_to_player.y *= -1
	dir_to_player.y += 18
	gneg_mirrored.position = otherside_center + dir_to_player
