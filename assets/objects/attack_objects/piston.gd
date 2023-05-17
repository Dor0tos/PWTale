extends Node2D

const Pistons_open_propability = 85
const Pistons_open_time = 0.5

func open():
	$AnimationPlayer.play("Open")

# Called when the node enters the scene tree for the first time.
func _ready():
	if randi() % 100 < Pistons_open_propability:
		var time = Pistons_open_time + float(randi() % 20 - 10) / 10.0
		await get_tree().create_timer(time).timeout
		open()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
