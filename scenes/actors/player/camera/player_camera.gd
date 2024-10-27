class_name PlayerCamera extends Camera2D

@export var target: Node2D
@export var smooth_weight: float = 0.1
@export var bounds_layer: TileMapLayer

func _ready() -> void:
	var bounds: Rect2 = bounds_layer.get_used_rect()
	limit_left = int(bounds.position.x + 1) * Globals.TILE_SIZE
	limit_top = int(bounds.position.y + 1) * Globals.TILE_SIZE
	limit_right = int(bounds.position.x + bounds.size.x - 1) * Globals.TILE_SIZE
	limit_bottom = int(bounds.position.y + bounds.size.y - 1) * Globals.TILE_SIZE

func target_exists() -> bool:
	if not target: return false
	return not target.is_queued_for_deletion()

func _physics_process(_delta: float) -> void:
	if not target_exists(): return
	position = position.lerp(target.position, smooth_weight)
