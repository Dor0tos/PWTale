extends Control

@export_range(0.01, 10, 0.1) var translation_duration : float = 1.0
@onready var diff = Global.Start_Difficulty
@export_range(0, 50, 1) var difficulty_modifier : int = 15

@export_category("Attacks settings")
@export_group("Piston attack")
## Скорость движения поршня сквозь панель в пиксельях в секндах
@export var Pistons_speed : float = 5
@export var Pistons_difficulty : Curve
@export_group("Slime attack")
@export var Immortal_time : float = 3
@export_group("TNT attack")
@export var TNT_difficulty : Curve
@export var Begin_time : float = 0.5
@export var Detonation_time : float = 1.0
@export var Tnt_period : float = 0.75
@export_group("Dispencer attack")
@export var Dispencer_difficulty : Curve


@onready var fight_panel = $Panel
@onready var attack_container = $Panel/Attack_Container
@onready var soul = $Soul
@onready var soul_size = $Soul/CollisionShape2D.shape.size
@onready var animation = $AnimationPlayer
@onready var soul_hitbox = $Soul/SoulDamage_area

@onready var holy_mantle = false

@onready var border = [
	$Panel/Border/Collision_1,
	$Panel/Border/Collision_2,
	$Panel/Border/Collision_3,
	$Panel/Border/Collision_4
]

@onready var border_area = [
	$Panel/Collision_Area/Collision_1,
	$Panel/Bottom_Area/Collision,
	$Panel/Collision_Area/Collision_3,
	$Panel/Collision_Area/Collision_4
]

@onready var entered_areas = []

const DEAFULT_SIZE = Vector2(248, 75) # 248 | 75

signal get_damage
signal get_heal
signal attack_finished

func _ready():
	_reset()
	$CanvasLayer/VBoxContainer3/VBoxContainer/Button5.grab_focus()

func _process(delta):
	apply_areas()
	
	$CanvasLayer/VBoxContainer3/VBoxContainer2/Label.text = str(
		$CanvasLayer/VBoxContainer3/VBoxContainer/HSlider.value
	) + " %"

func _reset():
	apply_size_immediately(DEAFULT_SIZE)
	soul.position = Vector2(0, 0)

func setup_for_attack(obj, clip = false):
	if clip:
		$Panel/Attack_Container_Clip.add_child(obj)
	else:
		$Panel/Attack_Container.add_child(obj)

func end_attack():
	apply_size(DEAFULT_SIZE)
	await get_tree().create_timer(translation_duration).timeout
	emit_signal("attack_finished")

func start_attack(id : int):
	_reset()
	
	if   id == 0:
		piston_attack(12 + int(diff * difficulty_modifier))
	elif id == 1:
		slime_attack(12 + int(diff * difficulty_modifier), 10)
	elif id == 2:
		tnt_attack(8 + int(diff * difficulty_modifier))
	elif id == 3:
		egg_attack(50, diff)
	elif id == 4:
		trident_attack(10, diff)
	elif id == 5:
		beakon_attack(10, diff)
	elif id == 6:
		arrow_attack(18 + floor(diff * 42), diff)
	elif id == 7:
		geoguesser_attack()

func apply_size_immediately(scale : Vector2):
	fight_panel.size = scale
	fight_panel.position = -scale / 2
	
	# Установка коллизий
	border[0].shape.size = Vector2(scale.x, 2)
	border[2].shape.size = Vector2(2, scale.y)
	
	border[0].position = Vector2(scale.x / 2, 1)
	border[1].position = Vector2(scale.x / 2, scale.y - 1)
	border[2].position = Vector2(1, scale.y / 2)
	border[3].position = Vector2(scale.x - 1, scale.y / 2)
	
	border_area[0].position = Vector2(scale.x / 2, 1)
	border_area[1].position = Vector2(scale.x / 2, scale.y - 1)
	border_area[2].position = Vector2(1, scale.y / 2)
	border_area[3].position = Vector2(scale.x - 1, scale.y / 2)

func apply_size(scale : Vector2):
	var tween : Tween = get_tree().create_tween()
	
	tween.parallel().tween_property(fight_panel, "size", scale, translation_duration)
	tween.parallel().tween_property(fight_panel, "position", -scale / 2, translation_duration)

	# Установка коллизий
	tween.parallel().tween_property(border[0].shape, "size",  Vector2(scale.x, 2), translation_duration)
	tween.parallel().tween_property(border[2].shape, "size", Vector2(2, scale.y), translation_duration)
	
	tween.parallel().tween_property(border[0], "position", Vector2(scale.x / 2, 1), translation_duration)
	tween.parallel().tween_property(border[1], "position", Vector2(scale.x / 2, scale.y - 1), translation_duration)
	tween.parallel().tween_property(border[2], "position", Vector2(1, scale.y / 2), translation_duration)
	tween.parallel().tween_property(border[3], "position", Vector2(scale.x - 1, scale.y / 2), translation_duration)
	
	tween.parallel().tween_property(border_area[0], "position", Vector2(scale.x / 2, 1), translation_duration)
	tween.parallel().tween_property(border_area[1], "position", Vector2(scale.x / 2, scale.y - 1), translation_duration)
	tween.parallel().tween_property(border_area[2], "position", Vector2(1, scale.y / 2), translation_duration)
	tween.parallel().tween_property(border_area[3], "position", Vector2(scale.x - 1, scale.y / 2), translation_duration)

func damage():
	soul_hitbox.monitoring = false
	animation.play("Damage")
	emit_signal("get_damage")
	await animation.animation_finished
	soul_hitbox.monitoring = true

func heal():
	animation.play("Heal")
	emit_signal("get_heal")

func apply_areas():
	for area in entered_areas:
		if (area.name.contains("damage")):
			damage()
		if (area.name.contains("heal")):
			heal()
		if (area.name.contains("still_dmg")) and is_moving():
			damage()
		if (area.name.contains("move_dmg")) and !is_moving():
			damage()

func is_moving():
	var moving_on_x = Input.get_axis("ui_left", "ui_right") != 0
	var moving_on_y = Input.get_axis("ui_up", "ui_down") != 0
	return moving_on_x or moving_on_y

func give_immortales(time : int):
	holy_mantle = true
	await get_tree().create_timer(time).timeout
	holy_mantle = false

# Обработка сигналов
func _on_area_2d_area_entered(area):
	if holy_mantle:
		return
	
	entered_areas.append(area)

func _on_collision_area_area_exited(area):
	entered_areas.remove_at(entered_areas.find(area))

# Атаки

# Атака 1 - Поршни
@onready var piston_obj = preload("res://assets/objects/attack_objects/piston.tscn")

func piston_attack(amount : int):
	apply_size(Vector2(58, 75))
	await get_tree().create_timer(1).timeout
	for i in range(amount):
		spawn_piston()
		await get_tree().create_timer(0.75 / (Pistons_difficulty.sample(diff) * 1.25)).timeout
	await get_tree().create_timer(1).timeout
	
	end_attack()

func spawn_piston():
	var piston = piston_obj.instantiate()
	var tween = create_tween()
	setup_for_attack(piston, true)
	var left = randi() % 2
	if left:
		piston.position = Vector2(16, -8)
		piston.rotation_degrees = 180
	else:
		piston.position = Vector2(fight_panel.size.x - 16, -8)
		piston.rotation_degrees = 0
	
	tween.tween_property(
		piston,
		"position",
		Vector2(piston.position.x, 83),
		91 / Pistons_speed / (Pistons_difficulty.sample(diff) * 1.25)
	)
	
	await tween.finished
	piston.queue_free()

# Атака 2 - Слизнь
@onready var slime_obj = preload("res://assets/objects/attack_objects/slime_block.tscn")

func slime_attack(speed : int, time : int):
	apply_size(Vector2(48, 75))
	await get_tree().create_timer(0.75).timeout
	give_immortales(Immortal_time)
	
	var blocks = []
	for i in range(3):
		blocks.append(slime_obj.instantiate())
		attack_container.add_child(blocks[blocks.size() - 1])
	blocks[0].position = Vector2(10, 11)
	blocks[1].position = Vector2(24, 37)
	blocks[2].position = Vector2(38, 63)
	await get_tree().create_timer(time).timeout
	for i in range(3):
		blocks[i].queue_free()
	
	end_attack()

# Атака 3 - Динамит
@onready var tnt_obj = preload("res://assets/objects/attack_objects/tnt.tscn")

func tnt_attack(amount : int):
	var screen_size = Vector2(50, 75)
	apply_size(screen_size)
	for i in range(amount):
		var tnt = tnt_obj.instantiate()
		tnt.init(Begin_time, Detonation_time)
		tnt.position = Vector2(
			randi() % int(screen_size.x),
			randi() % int(screen_size.y)
		)
		attack_container.add_child(tnt)
		await get_tree().create_timer(Tnt_period).timeout
	await get_tree().create_timer(2.5).timeout
	
	end_attack()

# Атака 4 - Яйца
@onready var egg_obj = preload("res://assets/objects/attack_objects/egg.tscn")
@onready var cock_obj = preload("res://assets/objects/attack_objects/cock.tscn")
@onready var cocks = []

func egg_attack(amount : int, difficulty : float):
	var screen_size = Vector2(75, 75)
	apply_size(screen_size)
	await get_tree().create_timer(translation_duration).timeout
	give_immortales(1.5)
	for i in range(amount + int(difficulty * 20)):
		var egg = egg_obj.instantiate()
		egg.position = Vector2(screen_size.x / 2, -10)
		egg.connect("cock_born", born_cock)
		setup_for_attack(egg)
		await get_tree().create_timer(0.1).timeout
	await get_tree().create_timer(1.5).timeout
	remove_cocks()
	
	end_attack()

func born_cock(pos):
	var cock = cock_obj.instantiate()
	cocks.append(cock)
	cock.scale.x = -1 if randi() % 2 == 0 else 1
	cock.position = Vector2(pos.x, DEAFULT_SIZE.y - 2)
	setup_for_attack(cock, true)

func remove_cocks():
	for cock in cocks:
		cock.queue_free()
	cocks = []

# Атака 5 - Трезубцы

@onready var tident_obj = preload("res://assets/objects/attack_objects/trident.tscn")
@onready var lighting_obj = preload("res://assets/objects/attack_objects/lightning.tscn")
@onready var last_pos = -1

func trident_attack(amount : int, difficulty : float):
	var screen_size = Vector2(37, 75)
	apply_size(screen_size)
	
	create_tween().tween_property(soul, "position", Vector2(0, 60/2), 0.2)
	
	for i in range(amount + int(difficulty * 10)):
		var trident = tident_obj.instantiate()
		trident.gravity_scale = difficulty + 0.7
		
		var pos = -1
		while pos == -1 or pos == last_pos:
			pos = randi() % 3
		last_pos = pos
		trident.position = Vector2(7.5 + 11 * pos, 0)
		
		trident.connect("hit_bottom", spawn_lighting)
		setup_for_attack(trident, true)
		
		await get_tree().create_timer(0.75).timeout
	await get_tree().create_timer(1.0).timeout
	
	end_attack()

func spawn_lighting(pos):
	var lighting = lighting_obj.instantiate()
	lighting.scale.x = -1 if randi() % 2 == 0 else 1
	lighting.position = Vector2(pos.x, DEAFULT_SIZE.y - 2)
	setup_for_attack(lighting, true)

# Атака 6 - Маяк
@onready var beakon_obj = preload("res://assets/objects/attack_objects/beakon.tscn")

func beakon_attack(amount : int, difficulty : float):
	var screen_size = Vector2(150, 75)
	var gen_margin = 15
	apply_size(screen_size)
	await get_tree().create_timer(translation_duration).timeout
	for i in range(amount + int(difficulty * 10)):
		var beakon = beakon_obj.instantiate()
		
		var pos : Vector2 = Vector2(
			randf() * (screen_size.x + 2 * gen_margin) - gen_margin,
			randf() * (screen_size.y + 2 * gen_margin) - gen_margin
		)
		while is_point_in_area(pos, screen_size):
			pos = Vector2(
				randf() * (screen_size.x + 2 * gen_margin) - gen_margin,
				randf() * (screen_size.y + 2 * gen_margin) - gen_margin
			)
		
		beakon.position = pos
		var beakon_global_pos = fight_panel.position + attack_container.position + pos
		var angle = Vector2.UP.angle_to(beakon_global_pos.direction_to(soul.position))
		print(angle * 180 / PI)
		beakon.rotation = angle
		setup_for_attack(beakon)
		await get_tree().create_timer(calc_difficult_time(difficulty)).timeout
	await get_tree().create_timer(1.5).timeout
	
	end_attack()

func calc_difficult_time(diff):
	return sqrt(0.54/0.91 - 0.54 * diff * diff / (1.728 * 0.91))

func is_point_in_area(point: Vector2, area : Vector2) -> bool:
	var in_x : bool = (point.x >= 0) and (point.x <= area.x)
	var in_y : bool = (point.y >= 0) and (point.y <= area.x)
	return in_x and in_y

# Атака 7 - Раздатчики
@onready var dispencer_obj = preload("res://assets/objects/attack_objects/dispencer.tscn")
@onready var arrow_obj = preload("res://assets/objects/attack_objects/arrow.tscn")

func arrow_attack(amount : int, difficulty : float):
	var screen_size = Vector2(150, 58)
	var dispencers = []
	apply_size(screen_size)
	await get_tree().create_timer(translation_duration).timeout
	for i in range(6):
		var dispencer = dispencer_obj.instantiate()
		dispencer.position = Vector2(
			screen_size.x * (i % 2) + (1 if i % 2 == 0 else -1),
			9 + 8 * i
		)
		dispencers.append(dispencer)
		setup_for_attack(dispencer)
		await get_tree().create_timer(0.1).timeout
	
	var arrow_speed = 1.25 - Dispencer_difficulty.sample(difficulty)
	for i in range(amount):
		var id = i % dispencers.size()
		dispencers[id].shoot()
		spawn_arrow(dispencers[id], arrow_speed)
		await get_tree().create_timer(Dispencer_difficulty.sample(difficulty)).timeout
	
	await get_tree().create_timer(screen_size.x / arrow_speed / 60).timeout
	
	for i in range(6):
		dispencers[i].queue_free()
	await get_tree().create_timer(0.1).timeout
	
	end_attack()

func spawn_arrow(dispencer, speed: float):
	await dispencer.arrow_shooted
	var arrow = arrow_obj.instantiate()
	var is_to_right = dispencer.position.x == 1
	arrow.init_bool(is_to_right, speed)
	arrow.position = Vector2(
		dispencer.position.x + (8 if is_to_right else -8),
		dispencer.position.y
	)
	setup_for_attack(arrow, true)

# Атака 8 - Геогесер
@onready var geo_obj = preload("res://assets/objects/attack_objects/geoguesser.tscn")
@onready var geo_timer_obj = preload("res://assets/objects/attack_objects/geo_timer.tscn")

func geoguesser_attack():
	animation.play("geo_begin")
	var screen_size = Vector2(100, 60)
	apply_size_immediately(screen_size)
	soul.set_skin(1)
	var geo = geo_obj.instantiate()
	var geo_timer = geo_timer_obj.instantiate()
	geo.position = screen_size / 2.0
	geo_timer.position = Vector2(screen_size.x / 2, screen_size.y)
	setup_for_attack(geo)
	setup_for_attack(geo_timer)

# Атака 9 - Пепе
# Атака X - Элэи <Отменена>

# Debug Part
# DELETE THIS!
func _on_h_slider_drag_ended(value_changed):
	diff = $CanvasLayer/VBoxContainer3/VBoxContainer/HSlider.value / 100.0

func _on_button_pressed(attack_type : int):
	start_attack(attack_type)
