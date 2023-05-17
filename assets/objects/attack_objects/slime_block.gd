extends Node2D

var Speed = Vector2(0, 0.75)
@export_enum("Top:-1", "Bottom:1") var start_dir = 1

func _ready():
	Speed *= start_dir

func _process(delta):
	position += Speed + Vector2(0, delta)


func _on_collision_detecter_area_entered(area):
	if area.name == "Collision_Area" or area.name == "Bottom_Area":
		if Speed.y > 0:
			$AnimationPlayer.play("Bottom_collision")
		else:
			$AnimationPlayer.play("Top_collision")
		Speed *= -1
