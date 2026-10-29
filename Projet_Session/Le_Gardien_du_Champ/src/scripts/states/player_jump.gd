extends BaseState

func enter() -> void:
    player.velocity.y = Player.JUMP_FORCE
    player.play_animation("Jump")

func physics_update(delta: float) -> void:
    player.apply_gravity(delta)
    player.horizontal_motion(delta)
    player.move_and_slide()
    if player.velocity.y >= 0.0:
        change_state("PlayerFall")
    elif Input.is_action_just_pressed("attack"):
        change_state("PlayerAttack")

func handle_input(event: InputEvent) -> void:
    if event.is_action_pressed("attack"):
        change_state("PlayerAttack")
