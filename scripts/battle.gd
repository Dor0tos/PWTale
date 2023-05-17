extends CanvasLayer

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

@onready var buttons = [
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Battle Button",
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Action Button",
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Items Button",
	$"Panel/MainPanel/VBoxContainer/ButtonsPanel/Mercy Button"
]

class Item:
	var Name : String
	var HealthRestore : int
	
	func _init(_name, _hr):
		Name = _name
		HealthRestore = _hr

@onready var inv = [
	Item.new("Монстр-Конфета", 10), # 0
	Item.new("Паучий пончик", 12), # 0
	Item.new("Лег. герой", 40), # 0
	Item.new("Лег. герой", 40), # 0
	
	Item.new("Лег. герой", 40), # 1
	Item.new("Лег. герой", 40), # 1
	Item.new("Гламбург.", 27), # 1
	Item.new("Гламбург.", 27), # 1
	
	Item.new("Хот-дог", 20), # 2
	Item.new("Хот-кэт", 21), # 2
]

func _ready():
	fight_panel.diff = 0
	
	selected_button = 0
	text_panel.run_mode = 1
	hp_bar._set_current_health(92)
	hide_panels()
	_end_attack()
	draw_button()

func draw_button():
	for i in range(4):
		buttons[i].change_selection_status(i == selected_button)

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
	inv.remove_at(inv.find(item))
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
	for item in inv:
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
	_action_end()

@onready var attack_stack = []
func _begin_attack():
	fight_panel.visible = true
	fight_panel.diff = clamp(fight_panel.diff + 0.03, 0, 1)
	fight_panel.get_tree().paused = false
	var attack_id = randi() % 7
	while attack_stack.find(attack_id) != -1:
		attack_id = randi() % 7
	
	attack_stack.push_back(attack_id)
	if attack_stack.size() > 3:
		attack_stack.pop_front()
	
	fight_panel.start_attack(attack_id)

func _end_attack():
	fight_panel.get_tree().paused = false
	fight_panel.visible = false
	back_panel.visible = true

# Обработка событий
# Карта событий
# [Битва] -  [PWGood]
# [Действ] - [PWGood] - [Осмотреть] - /Показать текст/ - Х
#                     - [Рассказать анекдот] - /Показать текст/ - /Анимация/ - Х
#                     - [Вкинуть пасту] - /Показать текст/ - /Анимация/ - Х

func _battle_PWGood(arg):
	var base_dmg = 10
	
	decide_panel.deactivate()
	bottom_panel_active = false
	disable_buttons()
	attack_panel.begin_attack()
	Global.set_focus(attack_panel, true)
	await attack_panel.attack
	var damage = (base_dmg + randi() % 5) * attack_panel.area_stack[0]
	PWGood.hit(damage)
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

func mercy_PWGood(arg):
	decide_panel.deactivate()
	text_panel.reset_text()
	text_panel.add_text("Похоже Пугод не собирается жалеть вас...")
	text_panel.show_textbox()
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

func _action_end():
	hide_panels()
	decide_panel.deactivate()
	actions_stack = []
	
	_begin_attack()
	await fight_panel.attack_finished
	
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
	
	SceneTransition.change_scene(null, "res://Scenes/base_scene.tscn")

func _on_attack_template_attack_finished():
	_end_attack()


func _on_attack_template_get_damage():
	hp_bar.Health_Cur = clampi(hp_bar.Health_Cur - (PWGood.damage + (randi() % 10 - 5)), 0, 999)
	
	if hp_bar.Health_Cur == 0:
		Global.soul_position = fight_panel.soul.global_position
		get_tree().change_scene_to_file("res://Scenes/death_screen.tscn")
