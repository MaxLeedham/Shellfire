class_name ManyEnemiesEvent extends Event

@export var duration: float = 40
@export var multiplier: float = 3

func start(main: Main) -> void:
	var max_before = main.max_enemy_count
	var chance_before = main.spawn_chance
	main.max_enemy_count = int(max_before * multiplier)
	main.spawn_chance = 1
	await main.get_tree().create_timer(duration).timeout
	main.max_enemy_count = max_before
	main.spawn_chance = chance_before
	finished.emit()
