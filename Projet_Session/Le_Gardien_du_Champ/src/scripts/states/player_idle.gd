extends BaseState

func enter() -> void:
    player.play_animation("Idle")

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)
    player.horizontal_motion(delta)
    player.move_and_slide()
    if not player.is_on_floor():
        change_state("PlayerFall")
    elif Input.is_action_just_pressed("jump"):
        change_state("PlayerJump")
    elif Input.get_axis("left", "right") != 0.0:
        change_state("PlayerRun")
    elif Input.is_action_just_pressed("attack"):
        change_state("PlayerAttack")

func handle_input(event: InputEvent) -> void:
    if event.is_action_pressed("attack"):
        change_state("PlayerAttack")
