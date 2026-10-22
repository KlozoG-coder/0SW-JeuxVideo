extends Area2D

var start_y: float = 0.0
var time_passed: float = 0.0

func _ready() -> void:
    add_to_group("insects")
    start_y = position.y

func _process(delta: float) -> void:
    time_passed += delta
    position.y = start_y + sin(time_passed * 2.5) * 2.0
