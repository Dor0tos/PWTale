extends Node2D

enum Faces {
	PASSIVE_AGGRESSIVE = 0,
	PASSIVE_AGGRESSIVE_TALK = 1,
	CONFIDENT_TALK = 2,
	SILENT = 3,
	HIT = 4,
	FUNNY = 5,
	GEOGUESSER = 6,
	ULTRA_ANGER = 8,
	CONFIDENT = 9,
	WORRY = 10,
	DEAD = 12,
	LAST_WORDS = 13,
	LAST_WORDS_TALK = 14,
	CRINGE = 7
}

enum PWAnimation {
	DEFAULT,
	CRINGE
}

@onready var is_text_shown = false
@onready var health = 100
@export var damage = 10
const max_health = 250
signal text_shown
signal bubble_done
signal animation_finished
signal died

func get_health_width(value):
	return $Health_back.size.x * value / max_health

func animate_health():
	var tween = create_tween()
	
	$Health_back.visible = true
	tween.tween_property($Health_back/Health_front, "size", Vector2(get_health_width(health), $Health_back.size.y), 1.0)
	tween.tween_interval(.4)
	await tween.finished
	$Health_back.visible = false

func set_face(face : Faces):
	$PWBody.frame = face

func set_animation(animation : PWAnimation):
	$AnimationPlayer.play(get_animation_name(animation))

func die():
	$PWBody.visible = false
	$Hat.visible = false
	
	$PWGood_Death.die()
	await $PWGood_Death.pwgood_died
	emit_signal("died")

func get_animation_name(animation : PWAnimation):
	match animation:
		PWAnimation.DEFAULT:
			return "RESET"
		PWAnimation.CRINGE:
			return "Cringe"

func apply_label_size():
	$RichTextLabel.size.y = $RichTextLabel.get_content_height()

func _ready():
	set_animation(PWAnimation.DEFAULT)
	health = max_health

func _input(event):
	if Input.is_action_just_pressed("ui_accept") and is_text_shown:
		$RichTextLabel.visible = false
		emit_signal("bubble_done")

func hit_face():
	if health <= 0:
		set_face(Faces.DEAD)
	else:
		set_face(Faces.HIT)

func hit(damage : int):
	health -= damage
	$Damage_Label.text = str(damage)
	$AnimationPlayer.play("Hit")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("RESET")
	emit_signal("animation_finished")

func say(text):
	$RichTextLabel.visible = true
	is_text_shown = false
	$RichTextLabel.text = text
	$RichTextLabel.visible_characters = 0
	$RichTextLabel/Timer.start()

func _on_timer_timeout():
	$RichTextLabel.visible_characters += 1
	apply_label_size()
	if $RichTextLabel.visible_characters == $RichTextLabel.text.length():
		emit_signal("text_shown")
		is_text_shown = true
		$RichTextLabel/Timer.stop()
