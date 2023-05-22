extends Node2D

@onready var old_pos = Vector2.ZERO
@onready var new_pos = Vector2.ZERO
@onready var move_time = 0.5

func move_eye():
	while true:
		var tween = create_tween()
		old_pos = new_pos
		new_pos = Vector2(randf() * 16.0 - 8.0, randf() * 16.0 - 8.0)
		var dist = old_pos.distance_to(new_pos)
		while pow(new_pos.x, 2) + pow(new_pos.x, 2) > 64:
			new_pos = Vector2(randf() * 16.0 - 8.0, randf() * 16.0 - 8.0)
		tween.tween_property($Tulpe, "position", new_pos, move_time / dist)
		for i in range(randi() % 15 + 5):
			tween.tween_property($Tulpe,
			"position",
			new_pos + Vector2(randf() - 0.5, randf() - 0.5),
			0.01)
		await tween.finished

func _ready():
	move_eye()
