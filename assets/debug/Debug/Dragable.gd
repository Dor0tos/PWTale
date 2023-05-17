extends Node2D

var offset: Vector2
var isDragging: bool = false

func _ready():
	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton:
		if event.is_pressed():
			var mousePos = event.position
			if is_point_in_area(mousePos, $DragArea.position + position, $DragArea/CollisionShape2D.shape.size):
				offset = position - mousePos
				isDragging = true
		else:
			isDragging = false

func _process(delta):
	if isDragging:
		var mousePos = get_viewport().get_mouse_position()
		position = mousePos + offset

func is_point_in_area(point, pos, size):
	var in_x : bool = (point.x >= pos.x) and (point.x <= pos.x + size.x)
	var in_y : bool = (point.y >= pos.y) and (point.y <= pos.y + size.y)
	
	return in_x and in_y
