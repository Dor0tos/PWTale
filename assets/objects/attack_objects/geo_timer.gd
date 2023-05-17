extends Node2D

@onready var default_sound = preload("res://assets/sounds/timer_sount.wav")
@onready var end_sound = preload("res://assets/sounds/timer_ended.wav")

@onready var timer = $Timer
@onready var counts = false

const animation_time = 0.2

func _ready():
	$AudioPlayer.stream = default_sound
	$AudioPlayer.volume_db = -6
	$Panel/ProgressBar.position.y = -20
	$Panel/Panel2.position.y = -20

func set_up(time: int):
	timer.wait_time = time
	$Panel/ProgressBar.max_value = time
	$Panel/ProgressBar.value = time
	$Panel/Panel2/Label.text = str(time)
	$Panel/ProgressBar.get_theme_stylebox("fill").bg_color = Color.WHITE
	
	var tween = create_tween().set_ease(Tween.EASE_IN)
	tween.parallel().tween_property($Panel/ProgressBar, "position", Vector2(0, 0), animation_time)
	tween.parallel().tween_property($Panel/Panel2, "position", Vector2(80, 0), animation_time)

func start():
	counts = true
	timer.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if counts:
		$Panel/ProgressBar.value = timer.time_left
		$Panel/ProgressBar.get_theme_stylebox("fill").bg_color = Color.from_hsv(0, 1 - timer.time_left / timer.wait_time, 1)
		$Panel/Panel2/Label.text = str(ceil(timer.time_left))
		
		if timer.time_left <= 5:
			start_sound()

func start_sound():
	if $Sound_timer.is_stopped():
		$AudioPlayer.play()
		$Sound_timer.start()

func _on_timer_timeout():
	var tween = create_tween().set_ease(Tween.EASE_OUT)
	counts = false
	$AudioPlayer.volume_db = 6
	$AudioPlayer.stream = end_sound
	$AudioPlayer.play()
	$Sound_timer.stop()
	tween.parallel().tween_property($Panel/ProgressBar, "position", Vector2(0, -20), animation_time)
	tween.parallel().tween_property($Panel/Panel2, "position", Vector2(80, -20), animation_time)


func _on_sound_timer_timeout():
	$AudioPlayer.play()
