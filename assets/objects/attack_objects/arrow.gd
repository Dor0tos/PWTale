extends Node2D

@export_enum("Left: -1", "Right:1") var Direction = 1
@export var speed : float = 5

func init(_dir: int, _speed: float):
	speed = _speed
	Direction = _dir

func init_bool(_dir: bool, _speed: float):
	speed = _speed
	Direction = 1 if _dir else -1

func _ready():
	scale.x = Direction

func _process(delta):
	position += Vector2(speed * Direction, 0)

func _on__damage_area_area_entered(area):
	queue_free()
