extends CanvasLayer

@onready var battlefall = preload("res://assets/sounds/snd_battlefall.wav")
@onready var pause_obj = preload("res://Scenes/settings_screen_ingame.tscn")

signal pause_disabled
signal ui_transition_done

func _ready():
	pass

func pause_on(root):
	$AnimationPlayer.play("ui_first")
	await $AnimationPlayer.animation_finished
	
	get_tree().paused = true
	root.get_children()[2].add_child(Global.pause_menu)
	Global.pause_menu.selected_setting = 0
	Global.pause_menu.settings[0].select()
	
	$AnimationPlayer.play("ui_second")

func pause_off(root):
	$AnimationPlayer.play("ui_first")
	await $AnimationPlayer.animation_finished
	
	root.get_children()[2].remove_child(Global.pause_menu)
	get_tree().paused = false
	
	emit_signal("pause_disabled")
	
	$AnimationPlayer.play("ui_second")

func ui_transition(to: String, speed_scale = 1):
	$AnimationPlayer.speed_scale = speed_scale
	$AnimationPlayer.play("ui_first")
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_file(to)
	
	$AnimationPlayer.play("ui_second")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.speed_scale = 1
	get_tree().paused = false

func fall_in_final():
	$ColorRect.modulate = Color.WHITE
	$Soul_Icon.visible = true
	$Soul_Icon.position = Vector2(192, 108)
	
	$AnimationPlayer.play("fight")
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_file("res://Scenes/chat_catch.tscn")
	$AudioPlayer.stream = battlefall
	$AudioPlayer.play()
	var tween = create_tween().tween_property(
		$Soul_Icon,
		"position",
		Vector2(192, 108),
		Global.battle_transition_time
	)
	await tween.finished
	$ColorRect.modulate = Color.TRANSPARENT
	$Soul_Icon.visible = false
	$AnimationPlayer.play("RESET")

func fall_in_battle(player_pos : Vector2):
	$ColorRect.modulate = Color.WHITE
	$Soul_Icon.visible = true
	$Soul_Icon.position = player_pos
	
	$AnimationPlayer.play("fight")
	await $AnimationPlayer.animation_finished
	
	get_tree().change_scene_to_file("res://Scenes/battle.tscn")
	$AudioPlayer.stream = battlefall
	$AudioPlayer.play()
	var tween = create_tween().tween_property(
		$Soul_Icon,
		"position",
		Vector2(78, 196),
		Global.battle_transition_time
	)
	await tween.finished
	$ColorRect.modulate = Color.TRANSPARENT
	$Soul_Icon.visible = false
	$AnimationPlayer.play("RESET")

func change_scene(player, path : String, _offset : Vector2 = Vector2.ZERO) -> void:
	$AnimationPlayer.play("disolve")
	await $AnimationPlayer.animation_finished
	
	Global.travel_to(player, path, _offset)
	$AnimationPlayer.play_backwards("disolve")
