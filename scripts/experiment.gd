extends Node2D

enum Light_behaviour {
	WAVE = 2,
	PARTICLE = 1
}

@onready var screen_image = Light_behaviour.PARTICLE

func _on_lamp_state_changed():
	$AudioPlayer.play()
	if $Lamp.lamp_on:
		$ExperimantScreen.frame = screen_image
		if screen_image == Light_behaviour.PARTICLE:
			$ExperimantScreen.shown_text = [
				"На экране видно две чёткие, яркие полосы"
			]
		else:
			$ExperimantScreen.shown_text = [
				"На экране видно множесто полос"
			]
	else:
		$ExperimantScreen.frame = 0
		$ExperimantScreen.shown_text = [
			"Большой белый экран, сделанный из пластика",
			"Кажется он нужен, чтобы на него падал свет из лампы"
		]
		if screen_image == Light_behaviour.PARTICLE:
			screen_image = Light_behaviour.WAVE
		else:
			screen_image = Light_behaviour.PARTICLE
