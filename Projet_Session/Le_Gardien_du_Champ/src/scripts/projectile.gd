extends Area2D

const SPEED: float = 430.0
var direction: float = 1.0
var life_time: float = 1.8

func _ready() -> void:
    area_entered.connect(_on_area_entered)
    body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    position.x += direction * SPEED * delta
    life_time -= delta
    if life_time <= 0.0:
        queue_free()

func _on_area_entered(area: Area2D) -> void:
    if area.is_in_group("insects"):
        area.queue_free()
        queue_free()

func _on_body_entered(_body: Node2D) -> void:
    queue_free()
