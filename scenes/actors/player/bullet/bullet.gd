class_name Bullet extends Node2D

var velocity: Vector2

func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_timer_timeout() -> void:
	queue_free()

# so frustrating

func _on_hurtbox_hit() -> void:
	queue_free()
