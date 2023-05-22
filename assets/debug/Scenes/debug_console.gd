extends CanvasLayer

func print(objs):
	var current_string = ""
	for obj in objs:
		current_string += str(obj) + '|'
	$ColorRect/Label.text += '\n' + current_string
