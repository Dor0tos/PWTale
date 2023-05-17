extends Node2D

@onready var R1 = $BackgroundFight_R1
@onready var R2 = $BackgroundFight_R2
@onready var R3 = $BackgroundFight_R3
@onready var R4 = $BackgroundFight_R4

@export var period : float = 5
@export var amplitude : int = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func sine(x, phi):
	return amplitude * sin(x * PI / period + phi)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
