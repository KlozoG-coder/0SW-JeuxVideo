class_name Player
extends CharacterBody2D

const SPEED: float = 220.0
const JUMP_FORCE: float = -400.0
const GRAVITY: float = 1050.0
const MAX_FALL_SPEED: float = 750.0
const PROJECTILE_SCENE: PackedScene = preload("res://scenes/Projectile.tscn")

@onready var sprite: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    _create_animations()

func apply_gravity(delta: float) -> void:
    if not is_on_floor():
        velocity.y = minf(velocity.y + GRAVITY * delta, MAX_FALL_SPEED)

func horizontal_motion(delta: float) -> void:
    var direction: float = Input.get_axis("left", "right")
    velocity.x = move_toward(velocity.x, direction * SPEED, 1200.0 * delta)
    if direction != 0.0:
        sprite.flip_h = direction < 0.0

func fire_projectile() -> void:
    var projectile := PROJECTILE_SCENE.instantiate()
    get_tree().current_scene.add_child(projectile)
    var facing: float = -1.0 if sprite.flip_h else 1.0
    projectile.global_position = global_position + Vector2(26.0 * facing, -14.0)
    projectile.direction = facing

func play_animation(name: String) -> void:
    if anim.current_animation != name or not anim.is_playing():
        anim.play(name)

func _create_animations() -> void:
    # 8 colonnes x 5 lignes: Idle, Run, Jump, Fall, attack.
    var library := AnimationLibrary.new()
    var definitions := {"Idle": [0, 8, 0.14, true], "Run": [8, 8, 0.09, true], "Jump": [16, 1, 0.12, false], "Fall": [24, 1, 0.12, false], "attack": [32, 8, 0.07, false]}
    for animation_name in definitions:
        var values: Array = definitions[animation_name]
        var animation := Animation.new()
        var frame_count: int = values[1]
        var step: float = values[2]
        animation.length = maxf(frame_count * step, 0.12)
        animation.loop_mode = Animation.LOOP_LINEAR if values[3] else Animation.LOOP_NONE
        var track: int = animation.add_track(Animation.TYPE_VALUE)
        animation.track_set_path(track, NodePath("Sprite2D:frame"))
        animation.value_track_set_update_mode(track, Animation.UPDATE_DISCRETE)
        for i in range(frame_count):
            animation.track_insert_key(track, i * step, values[0] + i)
        library.add_animation(animation_name, animation)
    anim.add_animation_library("", library)
