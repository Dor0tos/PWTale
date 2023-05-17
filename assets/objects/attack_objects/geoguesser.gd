extends Node2D

@export var monitoriong_object : Node2D
@export_color_no_alpha var HighlightColor = Color(0.14, 0.62, 0.87)

@onready var selected_area = ""
@onready var allow_to_choose = false

func _ready():
	pass

func _process(delta):
	pass

func Deselect_Zone(zone: Sprite2D):
	zone.modulate = Color.WHITE

func Select_Zone(zone: Sprite2D):
	zone.modulate = HighlightColor

func Zone_entered(area : Area2D, zone_name: String):
	if area.name != "_geoguesser_area" or !allow_to_choose:
		return
	selected_area = zone_name
	Select_Zone(get_node(zone_name))

func Zone_exited(area : Area2D, zone_name: String):
	if area.name != "_geoguesser_area":
		return
	selected_area = ""
	Deselect_Zone(get_node(zone_name))
