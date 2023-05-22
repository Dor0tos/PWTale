extends TextureRect

enum AnimationType{
	LEFT_TO_RIGHT,
	BOTTOM_TO_TOP
}

@export_enum("Left to right", "Bottom to top") var Animation_Type = 0 

func _ready():
	size = texture.get_size()

func select():
	var tween = create_tween()
	$AudioPlayer.play()
	if Animation_Type == AnimationType.LEFT_TO_RIGHT:
		$MarginContainer/ColorRect.size = Vector2(0, texture.get_size().y + 2)
		$MarginContainer/ColorRect.position.y = -1
		tween.tween_property(
			$MarginContainer/ColorRect,
			"size",
			texture.get_size() + Vector2.ONE * 2,
			0.1
		)
	elif Animation_Type == AnimationType.BOTTOM_TO_TOP:
		$MarginContainer/ColorRect.size = Vector2(texture.get_size().x + 2, 0)
		$MarginContainer/ColorRect.position.y = texture.get_size().y + 1
		tween.parallel().tween_property(
			$MarginContainer/ColorRect,
			"size",
			texture.get_size() + Vector2.ONE * 2,
			0.1
		)
		tween.parallel().tween_property(
			$MarginContainer/ColorRect,
			"position",
			Vector2.ZERO - Vector2.ONE,
			0.1
		)

func deselect():
	var tween = create_tween()
	if Animation_Type == AnimationType.LEFT_TO_RIGHT:
		$MarginContainer/ColorRect.size = Vector2(
			texture.get_size().x + 2,
			texture.get_size().y + 2)
		$MarginContainer/ColorRect.position.y = -1
		tween.tween_property(
			$MarginContainer/ColorRect,
			"size",
			Vector2(0, texture.get_size().y + 2),
			0.1
		)
	elif Animation_Type == AnimationType.BOTTOM_TO_TOP:
		$MarginContainer/ColorRect.size = Vector2(
			texture.get_size().x + 2,
			texture.get_size().y + 2)
		$MarginContainer/ColorRect.position.y = -1
		tween.parallel().tween_property(
			$MarginContainer/ColorRect,
			"size",
			Vector2(texture.get_size().x + 2, 0),
			0.1
		)
		tween.parallel().tween_property(
			$MarginContainer/ColorRect,
			"position",
			Vector2(-1, texture.get_size().y + 1),
			0.1
		)
