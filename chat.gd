extends Control

func add_message(nickname):
	$Panel/MarginContainer/Label.text += nickname + ": " + "[img height=6]res://assets/sprites/menus/hello_chat.png[/img][img height=6]res://assets/sprites/menus/cat.png[/img]\n"
	var debug = $Panel/MarginContainer/Label.get_line_count()
	if $Panel/MarginContainer/Label.get_line_count() > 6:
		$Panel/MarginContainer/Label.text = $Panel/MarginContainer/Label.text.right(
			-$Panel/MarginContainer/Label.text.find('\n') - 1
		)
