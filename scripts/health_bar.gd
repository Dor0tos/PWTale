extends Control

@export var Health_Cur = 20 : set = _set_current_health
@export var Health_Max = 20 : set = _set_max_health

@onready var cur_health_bar = $HBoxContainer/Control/Cur_Health_CR
@onready var max_health_bar = $HBoxContainer/Control/MaxHealth_CR

func _set_health(cur, max):
	Health_Cur = cur
	Health_Max = max

func _set_current_health(new_health):
	Health_Cur = new_health
	update_cur_health()

func _set_max_health(new_health):
	Health_Max = new_health
	update_max_health()

func update_max_health():
	if (max_health_bar == null):
		return
	max_health_bar.set_custom_minimum_size(Vector2(Health_Max / 2, 10))
	$HBoxContainer/MarginContainer2/Health_L.text = "%d/%d" % [Health_Cur, Health_Max]

func update_cur_health():
	if (cur_health_bar == null):
		return
	cur_health_bar.set_custom_minimum_size(Vector2(Health_Cur / 2, 10))
	$HBoxContainer/MarginContainer2/Health_L.text = "%d/%d" % [Health_Cur, Health_Max]

func _ready():
	update_max_health()
	update_cur_health()
