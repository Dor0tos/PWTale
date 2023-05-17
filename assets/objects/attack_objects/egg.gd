extends RigidBody2D

const force_modifier = 1000
signal cock_born(pos: Vector2)

func _ready():
	apply_force(Vector2((randi() % 10 - 5) * force_modifier, 0))
	await get_tree().create_timer(2).timeout
	queue_free()

func _on__damage_area_area_entered(area):
	if area.name == "Bottom_Area" and (randi() % 100 < 25):
		emit_signal("cock_born", self.position)
		queue_free()
