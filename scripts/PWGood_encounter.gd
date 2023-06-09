extends Node2D

const dialoge = preload("res://assets/text_window.tscn")

@export_range(1,3,1) var appear_count = 1
@export var enabled = true

@onready var talk_sound = preload("res://assets/sounds/pwgood_talk.mp3")

var last_encounter = false

signal pwgood_appear
signal pwgood_disappear
signal battle_begin

func _ready():
	switch()
	$AnimationPlayer.play("RESET")

func switch():
	$Area2D.monitoring = enabled

func _on_area_2d_body_entered(body):
	if body.name != "Gneg":
		return
	begin()
	if appear_count == 1:
		$AnimationPlayer.play("First_Appear")
	elif appear_count == 2:
		$AnimationPlayer.play("Second_Appear")
	elif appear_count == 3:
		$AnimationPlayer.play("Last_Appear")
		last_encounter = true

func begin():
	emit_signal("pwgood_appear")
	get_tree().paused = true

func end():
	emit_signal("pwgood_disappear")
	get_tree().paused = false
	queue_free()

func tell(text : PackedStringArray):
	await get_tree().create_timer(0.01).timeout
	var tw = dialoge.instantiate()
	
	for s in text:
		tw.add_text(s)
	get_tree().current_scene.add_child(tw)
	
	tw.set_portrait_picture("res://assets/PWGood_portrait.png")
	tw.set_new_sound(talk_sound)
	tw.show_textbox()
	await tw.reading_ended
	get_tree().paused = true
	
	if !last_encounter:
		$AnimationPlayer.play("First_Disappear")
		await $AnimationPlayer.animation_finished
		end()
	else:
		emit_signal("battle_begin")
		Global.Pre_Battle_Inventory = Global.Inventory.duplicate(true)
		end()
