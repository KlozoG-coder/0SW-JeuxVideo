class_name StateMachine
extends Node

@export var initial_state: BaseState
var current_state: BaseState
var states: Dictionary = {}

func _ready() -> void:
	for child in get_children():
		if child is BaseState:
			child.player = get_parent() as CharacterBody2D
			states[child.name.to_lower()] = child
			child.transitioned.connect(_on_transition)
	call_deferred("_start")

func _start() -> void:
	if initial_state:
		current_state = initial_state
		current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func _unhandled_input(event: InputEvent) -> void:
	if current_state:
		current_state.handle_input(event)

func _on_transition(from_state: BaseState, target: String) -> void:
	if from_state != current_state:
		return
	var next_state: BaseState = states.get(target.to_lower())
	if next_state == null:
		push_warning("Unknown state: " + target)
		return
	current_state.exit()
	current_state = next_state
	current_state.enter()
