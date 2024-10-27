class_name Enemy extends CharacterBody2D

@export var target: Node2D
@export var speed: float = 150
@export var acceleration: float = 25

@onready var sprite: Sprite2D = %Sprite2D
@onready var nav_agent: NavigationAgent2D = %NavigationAgent2D
@onready var hurtbox: Hurtbox = %Hurtbox
@onready var cooldown: Timer = %Cooldown
@onready var anim_player: AnimationPlayer = %AnimationPlayer
@onready var state_chart: StateChart = %StateChart

func target_exists() -> bool:
	if not target: return false
	return not target.is_queued_for_deletion()

func _on_idling_state_physics_processing(_delta: float) -> void:
	if target_exists():
		state_chart.send_event("target_spotted")

func _on_chasing_state_physics_processing(_delta: float) -> void:
	if not target_exists(): return
	if position.distance_to(target.position) <= nav_agent.target_desired_distance and cooldown.is_stopped():
		state_chart.send_event("attack")
		return
	nav_agent.target_position = target.position
	var next_pos: Vector2 = nav_agent.get_next_path_position()
	hurtbox.rotation = Vector2.RIGHT.angle_to(to_local(target.position))
	nav_agent.velocity = position.direction_to(next_pos) * speed
	nav_agent.max_speed = speed

func _on_nav_agent_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = velocity.move_toward(safe_velocity, acceleration)
	move_and_slide()

func _on_chasing_state_exited() -> void:
	nav_agent.velocity = Vector2.ZERO

func _on_attacking_state_entered() -> void:
	anim_player.play("attack")
	await anim_player.animation_finished
	cooldown.start()
	state_chart.send_event("attack_finished")

func _on_aggro_state_physics_processing(_delta: float) -> void:
	if not target_exists():
		state_chart.send_event("target_lost")

func _on_hitbox_hit(_damage: float) -> void:
	var before = modulate
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = before

func _on_health_depleated() -> void:
	queue_free()
