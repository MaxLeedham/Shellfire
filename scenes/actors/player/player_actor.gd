class_name PlayerActor extends CharacterBody2D

@export var speed: float = 300
@export var acceleration: float = 50
@export var bullet_scene: PackedScene
@export var bullet_speed: float = 500
@export var rotate_speed: float = 4

@onready var sprite: Sprite2D = %Sprite2D
@onready var bullet_pivot: Node2D = %BulletPivot
@onready var bullet_spawn: Marker2D = %BulletSpawn

var facing: Vector2 = Vector2.RIGHT

func _physics_process(_delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	
	if Input.is_action_pressed("rotate"):
		bullet_pivot.rotation += deg_to_rad(1) * rotate_speed
		if bullet_pivot.rotation > deg_to_rad(360):
			bullet_pivot.rotation = 0
	
	sprite.flip_h = facing.x < 0
	velocity = velocity.move_toward(direction * speed, acceleration)
	move_and_slide()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		facing = Vector2.LEFT
	elif event.is_action_pressed("right"):
		facing = Vector2.RIGHT
	elif event.is_action_pressed("up"):
		facing = Vector2.UP
	elif event.is_action_pressed("down"):
		facing = Vector2.DOWN
	if event.is_action_pressed("fire"):
		fire()

func fire() -> void:
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.position = bullet_spawn.global_position
	bullet.velocity = bullet_pivot.global_position.direction_to(bullet.position) * bullet_speed
	get_parent().add_child(bullet)

func _on_hitbox_hit(damage: float) -> void:
	var before = sprite.modulate
	sprite.modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	sprite.modulate = before
	Player.health -= damage
