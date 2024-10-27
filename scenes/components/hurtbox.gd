class_name Hurtbox extends Area2D

@export var damage: float = 1

signal hit

func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		area.hurt(damage)
		hit.emit()

# red = w
# blue = 2
# yellow = s
# orange = a
# green = d
# unmarked = 1
