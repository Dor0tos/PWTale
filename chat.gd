extends Control

func add_message(nickname):
	$Panel/MarginContainer/Label.text += nickname + ": " + "[img height=6]res://assets/sprites/menus/hello_chat.png[/img][img height=6]res://assets/sprites/menus/cat.png[/img]\n"
