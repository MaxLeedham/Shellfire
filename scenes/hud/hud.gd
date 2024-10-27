extends CanvasLayer

@onready var health_bar: Sprite2D = %HealthBar
@onready var hint_label: Label = %HintLabel

func _ready() -> void:
	Player.health_changed.connect(_on_health_changed)

func _on_health_changed():
	health_bar.scale.x = Player.health / Player.MAX_HEALTH

func display_message(message: String, duration: float = 2):
	hint_label.text = message
	await get_tree().create_timer(duration).timeout
	hint_label.text = ""
