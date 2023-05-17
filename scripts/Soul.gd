extends CharacterBody2D

@onready var default_skin = preload("res://assets/sprites/soul.png")
@onready var geo_skin = preload("res://assets/sprites/soul_geo.png")

const SPEED = 100.0

func set_skin(id : int):
	if id == 0:
		$Soul.texture = default_skin
	elif id == 1:
		$Soul.texture = geo_skin

func _physics_process(delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = 0
	var direction_y = 0
	
	direction_x = Input.get_axis("ui_left", "ui_right")
	direction_y = Input.get_axis("ui_up", "ui_down")
	
	if direction_x:
		velocity.x = direction_x * SPEED
	else:
		velocity.x = 0
	
	if direction_y:
		velocity.y = direction_y * SPEED
	else:
		velocity.y = 0
	velocity = velocity.normalized()
	
	velocity *= SPEED
	move_and_slide()
