class_name SlowDownEvent extends Event

@export var duration: float = 20
@export var multiplier: float = 0.6

func start(main: Main) -> void:
	var speed_before = main.player.speed
	var mod_before = main.player.sprite.modulate
	if main.player_exists():
		main.player.speed = int(speed_before * multiplier)
		main.player.sprite.modulate = Color("17f4f9")
	await main.get_tree().create_timer(duration).timeout
	if main.player_exists():
		main.player.speed = speed_before
		main.player.sprite.modulate = mod_before
	finished.emit()
