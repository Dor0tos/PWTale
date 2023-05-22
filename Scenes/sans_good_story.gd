extends Control

@onready var lines = [
	"Ну вот и всё",
	"Неплохая получилась история:",
	"Интересная, весёлая",
	"Порой грустная, но главное поучительная",
	"Она научила нас быть смелыми и не бояться вызовов, которые готовит нам жизнь",
	"И самое главное, она научила нас любить",
	"И не сходить с пути, следуюя за мечтой"
]

signal text_shown

func _ready():
	await get_tree().create_timer(2).timeout
	for txt in lines:
		say(txt)
		await text_shown
		await get_tree().create_timer(1.5).timeout
	
	say("...")
	await text_shown
	await get_tree().create_timer(2).timeout
	say("А, и ещё кое-что")
	create_tween().tween_property(
		$AudioStreamPlayer2,
		"volume_db",
		-80,
		10
	)
	await text_shown
	await get_tree().create_timer(1.5).timeout
	say("Отдельная благодароность для очень важных людей на стриме")
	await text_shown
	await get_tree().create_timer(1.5).timeout
	SceneTransition.fall_in_final()

func say(text):
	$ColorRect/Label.visible_characters = 0
	$ColorRect/Label.text = text
	$Timer.start()

func _on_timer_timeout():
	if $ColorRect/Label.visible_characters == ($ColorRect/Label.text as String).length():
		$Timer.stop()
		emit_signal("text_shown")
	else:
		$ColorRect/Label.visible_characters += 1
		$AudioStreamPlayer.play()
		
