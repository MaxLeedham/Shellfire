class_name GummyBearEvent extends Event

@export var duration: float = 20
@export var new_change: float = 0.75

func get_bear_spawn(spawns: Array[Spawn]) -> Spawn:
	for spawn in spawns:
		if spawn.id == Main.EnemyType.BEAR:
			return spawn
	return null

func start(main: Main) -> void:
	var spawn: Spawn = get_bear_spawn(main.spawns)
	var before = spawn.chance
	spawn.chance = new_change
	main.update_spawns()
	await main.get_tree().create_timer(duration).timeout
	spawn.chance = before
	main.update_spawns()
	finished.emit()
