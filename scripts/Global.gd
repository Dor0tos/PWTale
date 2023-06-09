extends Node

var player_pos : Array = []
var soul_position = Vector2.ZERO

enum DifficultyMode {
	EASY,
	MODERATE,
	HARD,
	EXTREME
}

var Difficulty_Mode : DifficultyMode = DifficultyMode.MODERATE

enum ScreenMode {
	WINDOWED,
	BORDERLESS_FULLSCREEN,
	FULLSCREEN
}

var screen_mode : ScreenMode = ScreenMode.WINDOWED

var Volume_settings = [0.54, 0.36, 0.42]
var Start_Difficulty = 0.3

var one_hit_mode = false
var Death_Count = 0

@onready var pause_obj = preload("res://Scenes/settings_screen_ingame.tscn")
var pause_menu

@onready var VolumeCurve = preload("res://Scenes/Volume_Curve.tres")

var prev_scene_path = ""
var Battle_Start_again = false
var interactive_states = [true, true, true, true, true, true, true]

class Item:
	var Name : String
	var HealthRestore : int
	
	func _init(_name, _hr):
		Name = _name
		HealthRestore = _hr

@onready var Inventory = [
	Item.new("Монстр-Конфета", 10), # 0
	Item.new("Лег. герой", 40), # 0
	Item.new("Лег. герой", 40), # 0
	Item.new("Лег. герой", 40), # 1
	Item.new("Гламбург.", 27), # 1
	Item.new("Гламбург.", 27), # 1
	Item.new("Хот-кэт", 21), # 2
]

@onready var Pre_Battle_Inventory = [
	Item.new("Монстр-Конфета", 10), # 0
	Item.new("Лег. герой", 40), # 0
	Item.new("Лег. герой", 40), # 0
	Item.new("Лег. герой", 40), # 1
	Item.new("Гламбург.", 27), # 1
	Item.new("Гламбург.", 27), # 1
	Item.new("Хот-кэт", 21), # 2
]

const battle_transition_time = 0.33

func save_data():
	var config = ConfigFile.new()

	config.set_value("Settings", "screen_mode", screen_mode)
	config.set_value("Settings", "Volume_settings", Volume_settings)
	config.set_value("Settings", "Difficulty_Mode", Difficulty_Mode)
	config.set_value("Settings", "OneHit_Mode", one_hit_mode)
	config.set_value("OT_DLC", "Death_Count", Death_Count)

	config.save("res://settings.cfg")

func load_data():
	var config = ConfigFile.new()

	# Load data from a file.
	var err = config.load("res://settings.cfg")

	# If the file didn't load, ignore it.
	if err != OK:
		return
	
	set_screen_mode(config.get_value("Settings", "screen_mode", screen_mode))
	set_volume(config.get_value("Settings", "Volume_settings", Volume_settings))
	set_difficulty(config.get_value("Settings", "Difficulty_Mode", Difficulty_Mode))
	set_one_hit(config.get_value("Settings", "OneHit_Mode", false))
	Death_Count = config.get_value("OT_DLC", "Death_Count", 0)

func _ready():
	load_data()
	pause_menu = pause_obj.instantiate()

func percentage_to_db(perc: float):
	return VolumeCurve.sample(perc) * -80.0

func set_one_hit(mode):
	one_hit_mode = mode

func set_difficulty(mode):
	Difficulty_Mode = mode
	
	if Difficulty_Mode == DifficultyMode.EASY:
		Start_Difficulty = 0.0
	elif Difficulty_Mode == DifficultyMode.MODERATE:
		Start_Difficulty = 0.25
	elif Difficulty_Mode == DifficultyMode.HARD:
		Start_Difficulty = 0.5
	elif Difficulty_Mode == DifficultyMode.EXTREME:
		Start_Difficulty = 0.75

func set_volume(map):
	Volume_settings = map
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Effects"),
		percentage_to_db(Global.Volume_settings[1])
	)
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Master"),
		percentage_to_db(Global.Volume_settings[0])
	)
	
	AudioServer.set_bus_volume_db(
		AudioServer.get_bus_index("Music"),
		percentage_to_db(Global.Volume_settings[2])
	)

func set_screen_mode(mode : ScreenMode):
	screen_mode = mode
	if screen_mode == ScreenMode.WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif screen_mode == ScreenMode.BORDERLESS_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	elif screen_mode == ScreenMode.FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

func add_item(_name : String, _hp : int):
	Inventory.append(Item.new(_name, _hp))
	Inventory.sort_custom(func(a, b): return a.Name < b.Name)

func travel_to(player, path : String, offset : Vector2 = Vector2.ZERO):
	if player != null:
		player_pos.push_back(player.position + offset)
	get_tree().change_scene_to_file(path)

func Color_rgba(r: float, g: float, b: float, a: float = 255.) -> Color:
	return Color(r / 255., g / 255., b / 255., a / 255.)

func set_focus(node, state):
	node.set_process_input(state)
