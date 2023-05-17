extends Control

@onready var area_stack = [miss_mod]
@onready var attack_modifier = 0

const miss_mod = 0.0
const low_mod = 0.5
const med_mod = 0.75
const high_mod = 1
const perfect_mod = 1.5

signal attack

func _ready():
	$Attack_Marker/Marker.monitorable = false
	$Area_Low.monitorable = false
	$Area_Med.monitorable = false
	$Area_High.monitorable = false
	$Area_Perfect.monitorable = false
	
	set_process_input(false)

func end_attack():
	$AnimationPlayer.play("attack")

func hide_panel():
	emit_signal("attack")
	visible = false
	
	$Attack_Marker/Marker.monitorable = false
	$Area_Low.monitorable = false
	$Area_Med.monitorable = false
	$Area_High.monitorable = false
	$Area_Perfect.monitorable = false
	
	set_process_input(false)

func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		end_attack()

func _on_marker_area_entered(area):
	if area.name == "Area_Low":
		area_stack.push_front(low_mod)
	elif area.name == "Area_Med":
		area_stack.push_front(med_mod)
	elif area.name == "Area_High":
		area_stack.push_front(high_mod)
	elif area.name == "Area_Perfect":
		area_stack.push_front(perfect_mod)

func _on_marker_area_exited(area):
	area_stack.pop_front()

func begin_attack():
	$Attack_Marker/Marker.monitorable = true
	$Area_Low.monitorable = true
	$Area_Med.monitorable = true
	$Area_High.monitorable = true
	$Area_Perfect.monitorable = true
	
	area_stack = [miss_mod]
	$AnimationPlayer.play("RESET")
	visible = true

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		area_stack = [miss_mod]
		hide_panel()
	else:
		end_attack()
