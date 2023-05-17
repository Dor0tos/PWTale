extends RigidBody2D
signal hit_bottom(pos : Vector2)

func _ready():
	freeze = true
	$AnimationPlayer.play("RESET")
	await get_tree().create_timer(0.6).timeout
	freeze = false
	$AudioPlayer.play()

func _on__damage_area_area_entered(area):
	if area.name == "Bottom_Area":
		emit_signal("hit_bottom", self.position)
		queue_free()
