extends Node

const MAX_HEALTH = 10

var health: float = MAX_HEALTH:
	set(new_value):
		health = min(max(new_value, 0), MAX_HEALTH)
		health_changed.emit()
		if health == 0:
			health_depleated.emit()

signal health_changed
signal health_depleated
