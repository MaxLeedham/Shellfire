class_name Main extends Node2D

const GUMMY_COLORS = [
	Color.AQUA,
	Color.CHARTREUSE,
	Color.BROWN,
	Color.CORAL,
	Color.CRIMSON,
	Color.DARK_ORANGE,
	Color.DARK_ORCHID,
	Color.DEEP_PINK,
	Color.GOLD,
	Color.ORANGE_RED,
	Color.GREEN_YELLOW,
	Color.CYAN,
	Color.CORNFLOWER_BLUE,
	Color.DARK_TURQUOISE
]

const MELLOW_COLORS = [Color.WHITE, Color.LIGHT_PINK]

enum EnemyType {
	GUMMY = 0,
	BEAR = 1,
	MARSHMELLOW = 2
}

@export var player_scene: PackedScene
@export var objects: Node2D
@export var player_camera: PlayerCamera
@export var bounds_layer: TileMapLayer
@export var enemies_group: String = "enemies"
@export_group("Spawn Settings")
@export var spawns: Array[Spawn]
@export var max_enemy_count: int = 26
@export var spawn_chance: float = 0.5
@export_group("Event Settings")
@export var min_event_internal: float = 10
@export var max_event_internal: float = 30
@export var events: Array[Event]

@onready var spawn_timer: Timer = %SpawnTimer
@onready var event_timer: Timer = %EventTimer
@onready var score_timer: Timer = %ScoreTimer

var bounds: Rect2
var player: PlayerActor

var score: int

func _ready() -> void:
	Player.health_depleated.connect(_on_player_health_depleated)
	bounds = bounds_layer.get_used_rect()
	spawn_player()
	update_spawns()
	events.sort_custom(sort_events)
	HUD.hint_label.text = "Welcome to Shellfire!\nShoot to start"

func spawn_player() -> void:
	player = player_scene.instantiate()
	player.position = (bounds.position + (bounds.size / 2)) * Globals.TILE_SIZE
	objects.add_child(player)
	player_camera.target = player
	Player.health = Player.MAX_HEALTH

func update_spawns():
	spawns.sort_custom(sort_spawns)

func sort_spawns(a: Spawn, b: Spawn):
	return a.chance < b.chance

func sort_events(a: Event, b: Event):
	return a.chance < b.chance

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("fire") and spawn_timer.is_stopped():
		HUD.hint_label.text = ""
		for enemy in get_tree().get_nodes_in_group(enemies_group):
			enemy.queue_free()
		if not player_exists():
			spawn_player()
		spawn_timer.start()
		event_timer.start(randf_range(min_event_internal, max_event_internal))
		score = 0
		score_timer.start()
		spawn_enemy()

func player_exists() -> bool:
	if not player: return false
	return not player.is_queued_for_deletion()

func get_random_spawn() -> Spawn:
	var i: float = randf()
	for spawn in spawns:
		if i < spawn.chance:
			return spawn
	return spawns.back()

func spawn_enemy() -> void:
	var x: float
	var y: float
	if randf() < 0.5:
		x = bounds.position.x if randf() < 0.5 else bounds.position.x + bounds.size.x
		y = randf_range(bounds.position.y, bounds.position.y + bounds.size.y)
	else:
		y = bounds.position.y if randf() < 0.5 else bounds.position.y + bounds.size.y
		x = randf_range(bounds.position.x, bounds.position.x + bounds.size.x)
	var spawn: Spawn = get_random_spawn()
	var enemy: Enemy = spawn.scene.instantiate()
	enemy.position = Vector2(x, y) * Globals.TILE_SIZE
	enemy.target = player
	enemy.add_to_group(enemies_group)
	match spawn.id:
		EnemyType.GUMMY,EnemyType.BEAR:
			enemy.modulate = GUMMY_COLORS.pick_random()
		EnemyType.MARSHMELLOW:
			enemy.modulate = MELLOW_COLORS.pick_random()
	objects.add_child(enemy)

func _on_spawn_timer_timeout() -> void:
	if not player_exists():
		spawn_timer.stop()
		return
	if randf() < spawn_chance and get_tree().get_node_count_in_group(enemies_group) < max_enemy_count:
		spawn_enemy()

func get_random_event() -> Event:
	var i: float = randf()
	for event in events:
		if i < event.chance:
			return event
	return events.back()

func _on_event_timer_timeout() -> void:
	var event: Event = get_random_event()
	HUD.display_message(event.name)
	event.start(self)
	await event.finished
	print("event finished!")
	event_timer.start(randf_range(min_event_internal, max_event_internal))

func _on_player_health_depleated() -> void:
	player.queue_free()
	spawn_timer.stop()
	event_timer.stop()
	score_timer.stop()
	HUD.hint_label.text = "Score: %s\nShoot to restart" % score

func _on_score_timer_timeout() -> void:
	score += 1
