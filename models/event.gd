class_name Event extends Resource

@export var name: String = "Event"
@export var chance: float = 1

signal finished

func start(main: Main) -> void:
	await main.get_tree().create_timer(2).timeout
	finished.emit()
