extends Node2D

@export var seek_object : Node2D = null
@export var nickname : String = "pwgood"
@onready var subTime : int
@onready var isModer : bool = false
@export var glow : bool = false
@export_color_no_alpha var color : Color = Color.GREEN
@export_flags("wave", "rainbow") var flags

signal catch(nick, time, isModer)

func _ready():
	var text_size = $Label.get_theme_font("normal_font").get_string_size(nickname, HORIZONTAL_ALIGNMENT_LEFT, -1, 8)
	$Label.size = text_size
	$Label.set("theme_override_colors/default_color", color)
	$Label.position = - $Label.size / 2.0
	$_health_area/CollisionShape2D.shape.size = $Label.size
	$Label.text = nickname
	if flags == 1:
		$Label.text = "[wave amp=25]" + $Label.text + "[/wave]"
	if flags == 2:
		$Label.text = "[rainbow]" + $Label.text + "[/rainbow]"
	if flags == 3:
		$Label.text = "[rainbow][wave]" + $Label.text + "[/wave][/rainbow]"
	if glow:
		$Label.set("theme_override_colors/font_shadow_color", Color.WHITE)
	else:
		$Label.set("theme_override_colors/font_shadow_color", Color.TRANSPARENT)

func _process(delta):
	if seek_object != null:
		var angle = position.angle_to_point(seek_object.position)
		if seek_object.position.x < position.x:
			angle += PI
		rotation = angle
	
	position += position.direction_to(seek_object.position) * 100 * delta

func _on__health_area_area_entered(area):
	if area.name == "_health_area":
		return
	else:
		$AudioStreamPlayer.play()
		$_health_area/CollisionShape2D.queue_free()
		visible = false
		await $AudioStreamPlayer.finished
		emit_signal("catch", nickname, subTime, isModer)
		queue_free()
