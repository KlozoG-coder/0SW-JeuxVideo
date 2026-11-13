extends Area2D

signal crop_damaged(amount: int)

@export var damage_interval: float = 3.0
var elapsed: float = 0.0

func _physics_process(delta: float) -> void:
	elapsed += delta
	if elapsed < damage_interval:
		return
	elapsed = 0.0
	for body in get_overlapping_areas():
		if body.is_in_group("insects"):
			crop_damaged.emit(10)
			return
