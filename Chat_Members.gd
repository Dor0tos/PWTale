extends Node

class Member:
	var nickname : String
	var is_moderator : bool
	var subscribtion_time : int
	
	func _init(_nick : String, _moder : bool, _time : int = 0):
		nickname = _nick
		is_moderator = _moder
		subscribtion_time = _time

func _ready():
	var file = FileAccess.open("res://data/data.json", FileAccess.READ)
	var text = file.get_as_text()
	var json = JSON.new()
	json.parse(text)
	file.close()
	
	for member in json.get_data():
		members.append(Member.new(member["name"], member["isModerator"], member["subCount"]))

@onready var members = []
