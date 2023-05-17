extends Node2D

# Параметры движения
@export var target : Node2D     # Объект, за которым следует текущий объект
var followSpeed = 100.0   # Скорость следования

func _process(delta: float) -> void:
	# Рассчитываем вектор направления до объекта
	var direction = (target.global_position - global_position).normalized()

	# Рассчитываем расстояние до объекта
	var distance = global_position.distance_to(target.global_position)

	if distance > 0.1:
		# Если объект находится достаточно далеко, продолжаем следовать за ним
		var newPosition = global_position + direction * followSpeed * delta
		global_position = newPosition
