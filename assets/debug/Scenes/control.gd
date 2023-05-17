extends Control

@onready var A = $ColorRect
@onready var B = $Follow

# Called when the node enters the scene tree for the first time.
func _ready():
	print(Vector2(2, 4).cross(Vector2(3, 2)))


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
