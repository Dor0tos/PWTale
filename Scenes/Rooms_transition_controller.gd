extends Node

@export var player : CharacterBody2D

func _ready():
	$"../Bedrock Room Entry"
	$"../Donut Room Entry"
	$"../Plants Room Entry"
	$"../Reverce Room Entry"
	$"../Cubes Room Entry"
	$"../Experiment Room Entry"
	$"../Wardrobe Room Entry"

func bedrock_room(body):
	SceneTransition.change_scene(
		player,
		"res://Scenes/bedrock_room.tscn",
		Vector2(0, 25)
	)
