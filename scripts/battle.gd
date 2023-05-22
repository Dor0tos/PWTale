extends CanvasLayer

@export var Difficulty_Curve : Curve

@onready var bottom_panel_active = true
@onready var selected_button = 0
@onready var prev_selected_button = -1
@onready var PWGood = $PWGood
@onready var back_panel = $Panel/MainPanel/VBoxContainer/TabPanels/Panel
@onready var fight_panel = $Panel/MainPanel/VBoxContainer/TabPanels/Attack_Template
@onready var attack_panel = $"Panel/MainPanel/VBoxContainer/TabPanels/Attack Panel"
@onready var hp_bar = $Panel/MainPanel/VBoxContainer/CharacterPanel/MarginContainer/HealthBar
@onready var decide_panel = $"Panel/MainPanel/VBoxContainer/TabPanels/Decide Panel"
@onready var text_panel = $Panel/MainPanel/VBoxContainer/TabPanels/TextWindow
@onready var actions_stack = []
@onready var is_attacking = false
@onready var final_stage = false
@onready var final_stage_begin = false

@onready var pw_dialogue = [
	"",
	"Зачем? Что тебе нужно было на моей базе?!"
]

@onready var buttons = [
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Battle Button",
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Action Button",
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Items Button",
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Mercy Button"
]

signal final_begin_ended

func _ready():
	
	selected_button = 0
	text_panel.run_mode = 1
	hp_bar._set_current_health(92)
	hide_panels()
	_end_attack()
	draw_button()
	
	sub_battle_text("Кажется теперь у вас проблемы")
	
	SceneTransition.connect("pause_disabled", pause_disabled)
	
	await get_tree().create_timer(1.0).timeout
	$AudioStreamPlayer.play()

func pwgood_say(text, face_id):
	bottom_panel_active = false
	back_panel.visible = true
	disable_buttons()
	PWGood.say(text)
	await PWGood.bubble_done
	bottom_panel_active = true
	enable_buttons()

func draw_button():
	for i in range(4):
		buttons[i].change_selection_status(i == selected_button)

func pause_disabled():
	AudioServer.set_bus_effect_enabled(
		AudioServer.get_bus_index("Music"), 0, false
	)
	create_tween().tween_property($AudioStreamPlayer, "volume_db", 12, 0.5)

func _input(event):
	if bottom_panel_active:
		if Input.is_action_just_pressed("ui_left"):
			selected_button = 3 if selected_button == 0 else selected_button - 1
			draw_button()
		if Input.is_action_just_pressed("ui_right"):
			selected_button = 0 if selected_button == 3 else selected_button + 1
			draw_button()
	
	if Input.is_action_just_pressed("ui_cancel"):
		if actions_stack.size() != 0:
			actions_stack.pop_front().call(null)
		elif !is_attacking:
			SceneTransition.pause_on(get_tree().get_root())
			AudioServer.set_bus_effect_enabled(
				AudioServer.get_bus_index("Music"), 0, true
			)
			create_tween().tween_property($AudioStreamPlayer, "volume_db", -6, 0.5)

func disable_buttons():
	if selected_button != -1:
		prev_selected_button = selected_button
	selected_button = -1
	for i in range(4):
		Global.set_focus(buttons[i], false)
	draw_button()

func enable_buttons():
	selected_button = prev_selected_button
	for i in range(4):
		Global.set_focus(buttons[i], true)
	draw_button()

func _on_action_button_pressed(sender):
	actions_stack.push_front(_return_back)
	
	decide_panel.deactivate()
	var options = [
		{ "Name" : "PWGood", "Action" : _action_PWGood, "Data" : 0}
	]
	bottom_panel_active = false
	disable_buttons()
	decide_panel.activate(options)

func restore_health(item):
	Global.Inventory.remove_at(Global.Inventory.find(item))
	decide_panel.deactivate()
	text_panel.reset_text()
	var debug = hp_bar.Health_Max - hp_bar.Health_Cur
	if item.HealthRestore < (hp_bar.Health_Max - hp_bar.Health_Cur):
		text_panel.add_text("Вы съели %s и восстановили %d ОЗ" % [item.Name, item.HealthRestore])
	else:
		text_panel.add_text("Вы съели %s и полностью восстановили ОЗ" % [item.Name])
	
	hp_bar.Health_Cur = clampi(hp_bar.Health_Cur + item.HealthRestore, 0, hp_bar.Health_Max)
	text_panel.show_textbox()
	await text_panel.text_shown
	_action_end()

func _on_items_button_pressed(sender):
	actions_stack.push_front(_return_back)
	
	decide_panel.deactivate()
	var options = []
	for item in Global.Inventory:
		options.append(
			{ "Name" : item.Name, "Action" : restore_health, "Data" : item}
		)
	bottom_panel_active = false
	disable_buttons()
	decide_panel.activate(options)

func _on_mercy_button_pressed(sender):
	actions_stack.push_front(_return_back)
	
	decide_panel.deactivate()
	var options = [
		{ "Name" : "PWGood", "Action" : mercy_PWGood, "Data" : 0},
		{ "Name" : "Бежать", "Action" : mercy_run, "Data" : 0}
	]
	bottom_panel_active = false
	disable_buttons()
	decide_panel.activate(options)

func _on_battle_button_pressed(sender):
	actions_stack.push_front(_return_back)
	
	decide_panel.deactivate()
	var options = [
		{ "Name" : "PWGood", "Action" : _battle_PWGood, "Data" : 0}
	]
	bottom_panel_active = false
	disable_buttons()
	decide_panel.activate(options)

func _return_back(arg):
	decide_panel.deactivate()
	actions_stack = []
	bottom_panel_active = true
	enable_buttons()

@onready var attack_stack = []
func _begin_attack():
	is_attacking = true
	fight_panel.visible = true
	fight_panel.get_tree().paused = false
	var attack_id = randi() % 7
	while attack_stack.find(attack_id) != -1:
		attack_id = randi() % 7
	
	attack_stack.push_back(attack_id)
	if attack_stack.size() > 3:
		attack_stack.pop_front()
	
	fight_panel.start_attack(attack_id)

func _end_attack():
	is_attacking = false
	fight_panel.get_tree().paused = false
	fight_panel.visible = false
	back_panel.visible = true

# Обработка событий
# Карта событий
# [Битва] -  [PWGood]
# [Действ] - [PWGood] - [Осмотреть] - /Показать текст/ - Х
#                     - [Рассказать анекдот] - /Показать текст/ - /Анимация/ - Х
#                     - [Вкинуть пасту] - /Показать текст/ - /Анимация/ - Х

func map_difficulty(diff_mode, map_value):
	fight_panel.diff = clamp(
		(diff_mode + Difficulty_Curve.sample(map_value)) * 0.25,
		diff_mode * 0.25,
		(diff_mode + 1) * 0.25 - 0.001
	)

func _battle_PWGood(arg):
	var base_dmg = 10
	
	sub_battle_text("")
	decide_panel.deactivate()
	bottom_panel_active = false
	disable_buttons()
	attack_panel.begin_attack()
	Global.set_focus(attack_panel, true)
	await attack_panel.attack
	var damage = (base_dmg + randi() % 5) * attack_panel.area_stack[0]
	PWGood.hit(damage)
	map_difficulty(Global.Difficulty_Mode, float(PWGood.health) / float(PWGood.max_health))
	if PWGood.health < 250: #PWGood.max_health * 0.2:
		final_stage = true
	var died = PWGood.health <= 0
	await PWGood.animation_finished
	if !died:
		_action_end()
	else:
		_last_words()

func _action_PWGood(arg):
	actions_stack.push_front(_on_action_button_pressed)
	
	decide_panel.deactivate()
	var options = [
		{ "Name" : "Осмотреть", "Action" : action_PWGood_look, "Data" : 0},
		{ "Name" : "Расск. анекдот", "Action" : action_PWGood_joke, "Data" : 0},
		{ "Name" : "Вкинуть пасту", "Action" : action_PWGood_pasta, "Data" : 0},
	]
	decide_panel.activate(options)

func action_PWGood_look(arg):
	decide_panel.deactivate()
	text_panel.reset_text()
	text_panel.add_text("ЗЩТ 255 АТК 25")
	text_panel.show_textbox()
	await text_panel.text_shown
	_action_end()

func action_PWGood_joke(arg):
	decide_panel.deactivate()
	text_panel.reset_text()
	text_panel.add_text("Вы рассказали лучший анекдот, который вам приходилось слышать")
	text_panel.show_textbox()
	await text_panel.text_shown
	PWGood.set_animation(1)
	PWGood.set_face(7)
	PWGood.say("Это.... ну не лучшая шутка...")
	await PWGood.bubble_done
	PWGood.set_animation(0)
	_action_end()

func action_PWGood_pasta(arg):
	decide_panel.deactivate()
	text_panel.reset_text()
	text_panel.add_text("Вы прислали уморительную пасту. Кажется на лице Пугода появилась улыбка")
	text_panel.show_textbox()
	await text_panel.text_shown
	PWGood.set_face(5)
	PWGood.say("*пх-пх-пх*")
	await PWGood.bubble_done
	PWGood.set_face(0)
	_action_end()

func sub_battle_text(text : String):
	text = "* " + text
	$Panel/MainPanel/VBoxContainer/TabPanels/Panel/MarginContainer/Label.text = text

func display_text(message : PackedStringArray):
	decide_panel.deactivate()
	text_panel.reset_text()
	for str in message:
		text_panel.add_text(str)
	text_panel.show_textbox()

func mercy_PWGood(arg):
	display_text(["Похоже Пугод не собирается жалеть вас..."])
	await text_panel.text_shown
	# ToDo: Добавить анимацию пугоду "Не впечатлён"
	_action_end()

func mercy_run(arg):
	decide_panel.deactivate()
	text_panel.reset_text()
	text_panel.add_text("Пугод не отпустит вас так просто")
	text_panel.show_textbox()
	await text_panel.text_shown
	# ToDo: Добавить анимацию пугоду "Не впечатлён"
	_action_end()

func hide_panels():
	fight_panel.visible = false
	attack_panel.visible = false
	decide_panel.visible = false
	text_panel.visible = false
	back_panel.visible = false

func first_geo_attack():
	final_stage_begin = true
	PWGood.set_animation(1)
	PWGood.set_face(6)
	await get_tree().create_timer(1).timeout
	PWGood.say_epic("Геогесер")
	await PWGood.bubble_done
	$AudioStreamPlayer.volume_db = 12
	$AudioStreamPlayer.play(15.5)
	sub_battle_text("Ситуация набирает обороты")
	fight_panel.emit_signal("attack_finished")

func begin_geoguesser_attack():
	if !final_stage_begin:
		first_geo_attack()
	
	hide_panels()
	is_attacking = true
	fight_panel.visible = true
	fight_panel.diff = clamp(fight_panel.diff + 0.03, 0, 1)
	fight_panel.get_tree().paused = false
	var attack_id = 7
	
	fight_panel.start_attack(attack_id)

func begin_final():
	create_tween().tween_property(
		$AudioStreamPlayer,
		"volume_db",
		-80,
		3
	)
	
	PWGood.set_animation(1)
	PWGood.set_face(3)
	PWGood.say("Всё, хватит...")
	await PWGood.bubble_done
	PWGood.say("...")
	await PWGood.bubble_done
	PWGood.say("...")
	await PWGood.bubble_done
	PWGood.set_face(11)
	PWGood.say("Погодите-ка")
	await PWGood.bubble_done
	PWGood.say("У меня есть идея получше")
	await PWGood.bubble_done
	PWGood.say("Поиграем в")
	await PWGood.bubble_done
	begin_geoguesser_attack()
	await fight_panel.attack_finished
	emit_signal("final_begin_ended")
	_end_attack()

func _action_end():
	hide_panels()
	decide_panel.deactivate()
	actions_stack = []
	
	_begin_attack()
	await fight_panel.attack_finished
	
	if pw_dialogue.size() != 0:
		if pw_dialogue[0] == "":
			pw_dialogue.pop_front()
			bottom_panel_active = true
			enable_buttons()
		else:
			pwgood_say(pw_dialogue.pop_front(), 0)
	else:
		bottom_panel_active = true
		enable_buttons()

enum Faces {
	PASSIVE_AGGRESSIVE = 0,
	PASSIVE_AGGRESSIVE_TALK = 1,
	CONFIDENT_TALK = 2,
	SILENT = 3,
	SURPRISED = 4,
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

func _last_words():
	is_attacking = true
	disable_buttons()
	actions_stack = []
	var tween = get_tree().create_tween()
	tween.tween_property($AudioStreamPlayer, "volume_db", -80, 2.5)
	
	decide_panel.deactivate()
	PWGood.set_animation(1)
	PWGood.set_face(Faces.DEAD)
	await get_tree().create_timer(1.2).timeout
	PWGood.set_face(Faces.LAST_WORDS)
	await get_tree().create_timer(0.4).timeout
	PWGood.set_face(Faces.LAST_WORDS_TALK)
	PWGood.say("Ты... добился своего... поздравляю...")
	await PWGood.bubble_done
	PWGood.set_face(Faces.LAST_WORDS)
	await get_tree().create_timer(1).timeout
	
	_last_action()

func _last_action():
	decide_panel.deactivate()
	
	PWGood.die()
	await PWGood.died
	
	text_panel.reset_text()
	text_panel.add_text("-10.000 rep на PepeLand получено")
	text_panel.show_textbox()
	await text_panel.text_shown
	
	#SceneTransition.ui_transition("res://Scenes/win_screen.tscn", 0.25)
	SceneTransition.ui_transition("res://Scenes/sans_good_story.tscn", 0.25)

func _on_attack_template_attack_finished():
	_end_attack()


func _on_attack_template_get_damage():
	hp_bar.Health_Cur = clampi(hp_bar.Health_Cur - (PWGood.damage + (randi() % 10 - 5)), 0, 999)
	
	if hp_bar.Health_Cur == 0:
		Global.soul_position = fight_panel.soul.global_position
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")
