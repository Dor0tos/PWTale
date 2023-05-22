extends Control

@onready var chat = $Chat_Members
@onready var person_obj = preload("res://assets/objects/attack_objects/chat_person.tscn")
@onready var switch = false

func _ready():
	$AnimationPlayer.play("RESET")
	await get_tree().create_timer(2.5).timeout
	show_lightmask()
	$Timer.start()
	await get_tree().create_timer(111).timeout
	$AnimationPlayer.play("finale")
	await $AnimationPlayer.animation_finished
	SceneTransition.ui_transition("res://Scenes/MainMenu.tscn")

func show_lightmask():
	await get_tree().create_timer(0.5).timeout
	create_tween().set_ease(Tween.EASE_IN).tween_property(
		$Lightmask,
		"modulate",
		Color(1, 1, 1, 0.75),
		0.1
	)

func spawn_random():
	print(chat.members.size())
	if chat.members.size() == 0:
		return
	var id = randi() % chat.members.size()
	
	var person = person_obj.instantiate()
	
	person.nickname = chat.members[id].nickname
	
	if chat.members[id].subscribtion_time < 1:
		person.color = Color.GREEN
	elif chat.members[id].subscribtion_time < 3:
		person.color = Color.YELLOW
	elif chat.members[id].subscribtion_time < 6:
		person.color = Color.CYAN
	elif chat.members[id].subscribtion_time < 9:
		person.color = Color.REBECCA_PURPLE
	elif chat.members[id].subscribtion_time < 12:
		person.color = Color.DARK_ORANGE
	elif chat.members[id].subscribtion_time < 18:
		person.color = Color.PINK
	elif chat.members[id].subscribtion_time < 24:
		person.flags = 2
	else:
		person.flags = 2
		person.glow = true
	
	person.seek_object = $Soul
	var out_offset = 80
	var in_offset = 30
	var pos = Vector2(
			randf() * (384 + out_offset * 2) - out_offset,
			randf() * (216.0 + out_offset * 2) - out_offset
		)
	while point_in_rect(pos, Vector2(-in_offset, -in_offset), Vector2(384 + in_offset * 2, 216 + in_offset * 2)):
		pos = Vector2(
			randf() * (384 + out_offset * 2) - out_offset,
			randf() * (216.0 + out_offset * 2) - out_offset
		)
	person.position = pos
	
	switch = !switch
	
	add_child(person)
	person.subTime = chat.members[id].subscribtion_time
	person.connect("catch", member_catch)
	
	chat.members.remove_at(id)

func member_catch(_name, _time, _isModer):
	var clr : Color
	if _time < 1:
		_name = "[color=" + Color.GREEN.to_html(false) + ']' + _name + "[/color]"
	elif _time < 3:
		_name = "[color=" + Color.YELLOW.to_html(false) + ']' + _name + "[/color]"
	elif _time < 6:
		_name = "[color=" + Color.CYAN.to_html(false) + ']' + _name + "[/color]"
	elif _time < 9:
		_name = "[color=" + Color.REBECCA_PURPLE.to_html(false) + ']' + _name + "[/color]"
	elif _time < 12:
		_name = "[color=" + Color.DARK_ORANGE.to_html(false) + ']' + _name + "[/color]"
	elif _time < 18:
		_name = "[color=" + Color.PINK.to_html(false) + ']' + _name + "[/color]"
	elif _time < 24:
		_name = "[rainbow]" + _name + "[/rainbow]"
	else:
		_name = "[rainbow]" + _name + "[/rainbow]"
		_name = "[outline_color=#ffffff]" + _name + "[/outline_color]"
		_name = "[outline_size=3]" + _name + "[/outline_size]"
	
	$Chat.add_message(_name)

func point_in_rect(point: Vector2, rect_pos: Vector2, rect_size : Vector2):
	var in_x = (point.x >= rect_pos.x) and (point.x <= rect_pos.x + rect_size.x)
	var in_y = (point.y >= rect_pos.y) and (point.y <= rect_pos.y + rect_size.y)
	return in_x and in_y
#39:13 - 51:04
# Прошло: 1:51
func _on_timer_timeout():
	spawn_random()
