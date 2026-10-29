class_name BaseState
extends Node

signal transitioned(from_state: BaseState, target: String)
var player: CharacterBody2D

func enter() -> void:
    pass

func exit() -> void:
    pass

func handle_input(_event: InputEvent) -> void:
    pass

func update(_delta: float) -> void:
    pass

func physics_update(_delta: float) -> void:
    pass

func change_state(target: String) -> void:
    transitioned.emit(self, target)
