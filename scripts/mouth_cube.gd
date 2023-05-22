extends Node2D

func _on_near_area_body_entered(body):
	if body.name == "Gneg":
		var tween = create_tween()
		tween.tween_property($MouthCube, "frame", 0, 0.05)
		tween.tween_property($MouthCube, "frame", 1, 0.05)
		tween.tween_property($MouthCube, "frame", 2, 0.05)

func _on_near_area_body_exited(body):
	if body.name == "Gneg":
		var tween = create_tween()
		tween.tween_property($MouthCube, "frame", 2, 0.05)
		tween.tween_property($MouthCube, "frame", 1, 0.05)
		tween.tween_property($MouthCube, "frame", 0, 0.05)
