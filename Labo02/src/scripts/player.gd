class_name Player
extends CharacterBody2D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
    _create_animations()
    anim.play("Idle")

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
