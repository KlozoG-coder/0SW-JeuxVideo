extends Area2D

signal defeated(points: int)

@export var patrol_distance: float = 90.0
@export var patrol_speed: float = 42.0
@export var chase_speed: float = 72.0
@export var detection_distance: float = 165.0
@export var max_health: int = 2

var health: int = 2
var start_position: Vector2
var patrol_direction: float = 1.0
var elapsed: float = 0.0
var target: CharacterBody2D

func _ready() -> void:
    add_to_group("insects")
    health = max_health
    start_position = global_position
    target = get_tree().get_first_node_in_group("player") as CharacterBody2D
    body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
    elapsed += delta
    var speed: float = patrol_speed
    if is_instance_valid(target) and global_position.distance_to(target.global_position) < detection_distance:
        patrol_direction = signf(target.global_position.x - global_position.x)
        speed = chase_speed
    elif absf(global_position.x - start_position.x) >= patrol_distance:
        patrol_direction = -1.0 if global_position.x > start_position.x else 1.0
    position.x += patrol_direction * speed * delta
    position.y = start_position.y + sin(elapsed * 3.0) * 4.0
    $Sprite2D.flip_h = patrol_direction < 0.0

func take_damage(amount: int = 1) -> void:
    health -= amount
    modulate = Color(1.0, 0.55, 0.55)
    if health <= 0:
        defeated.emit(100)
        queue_free()
    else:
        get_tree().create_timer(0.12).timeout.connect(_restore_color)

func _restore_color() -> void:
    if is_inside_tree():
        modulate = Color.WHITE

func _on_body_entered(body: Node2D) -> void:
    if body.is_in_group("player") and body.has_method("take_damage"):
        body.take_damage()
