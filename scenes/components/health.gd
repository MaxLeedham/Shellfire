class_name Health extends Node

@export var max_health: int = 10

@onready var health: float = max_health:
	set(new_value):
		health = min(max(new_value, 0), max_health)

signal depleated

func damage(amount: float) -> void:
	health -= amount
	if health == 0:
		depleated.emit()
