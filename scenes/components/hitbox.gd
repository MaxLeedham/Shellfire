class_name Hitbox extends Area2D

@export var immunity_time: float
@export var health: Health

@onready var immunity_timer: Timer = %ImmunityTimer

signal hit(damage: float)

func hurt(amount: float) -> bool:
	if not immunity_timer.is_stopped():
		return false
	if health:
		health.damage(amount)
	if immunity_time > 0:
		immunity_timer.wait_time = immunity_time
		immunity_timer.start()
	hit.emit(amount)
	return true
