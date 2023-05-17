extends Control

@onready var first_sound = preload("res://assets/sounds/snd_break1.wav")
@onready var second_sound = preload("res://assets/sounds/snd_break2.wav")

# Called when the node enters the scene tree for the first time.
func _ready():
	$Soul.position = Global.soul_position
	
	var tween = create_tween()
	
	for i in range(20):
		$Soul/Sprite2D.position = Vector2(randf(), randf()) * 2.5
		await get_tree().create_timer(0.05).timeout
	
	$Soul/Sprite2D.frame = 1
	$AudioPlayer.stream = first_sound
	$AudioPlayer.play()
	await get_tree().create_timer(1).timeout
	
	$Soul/Sprite2D.visible = false
	$AudioPlayer.stream = second_sound
	$AudioPlayer.play()
	$Soul/Soul_particles.emitting = true
	await get_tree().create_timer(1).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
