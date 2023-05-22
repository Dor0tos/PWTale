extends CharacterBody2D


const SPEED = 100.0

var is_reading = false

func _input(event):
	if event.is_action_pressed("ui_pause"):
		SceneTransition.pause_on(get_tree().get_root())

func _physics_process(_delta):
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction_x = 0
	var direction_y = 0
	if !is_reading:
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
	
	if velocity != Vector2.ZERO:
		$AnimationTree.get("parameters/playback").travel("Walk")
		$AnimationTree.set("parameters/Idle/blend_position", velocity)
		$AnimationTree.set("parameters/Walk/blend_position", velocity)
	else:
		$AnimationTree.get("parameters/playback").travel("Idle")
	
	velocity *= SPEED
	move_and_slide()
