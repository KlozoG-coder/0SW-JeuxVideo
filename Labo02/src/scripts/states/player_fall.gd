extends BaseState

func enter() -> void:
    player.play_animation("Fall")

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)
    player.horizontal_motion(delta)
    player.move_and_slide()
    if player.is_on_floor():
        if absf(Input.get_axis("left", "right")) > 0.0:
            change_state("PlayerRun")
        else:
            change_state("PlayerIdle")
    elif Input.is_action_just_pressed("attack"):
        change_state("PlayerAttack")

func handle_input(event: InputEvent) -> void:
    if event.is_action_pressed("attack"):
        change_state("PlayerAttack")
