extends BaseState

var finished: bool = false
var projectile_sent: bool = false

func enter() -> void:
    finished = false
    projectile_sent = false
    player.velocity.x = 0.0
    player.anim.play("attack")
    if not player.anim.animation_finished.is_connected(_on_animation_finished):
        player.anim.animation_finished.connect(_on_animation_finished)

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)
    player.velocity.x = 0.0
    player.move_and_slide()
    if not projectile_sent and player.anim.current_animation_position >= 0.14:
        projectile_sent = true
        player.fire_projectile()
    if finished:
        if not player.is_on_floor():
            change_state("PlayerFall")
        elif Input.get_axis("left", "right") != 0.0:
            change_state("PlayerRun")
        else:
            change_state("PlayerIdle")

func _on_animation_finished(animation_name: StringName) -> void:
    if animation_name == &"attack":
        finished = true

func exit() -> void:
    if player.anim.animation_finished.is_connected(_on_animation_finished):
        player.anim.animation_finished.disconnect(_on_animation_finished)
