extends Node2D

var score: int = 0
var game_over: bool = false
@onready var player: Player = $Player
@onready var hud: Label = $Help/Status
@onready var message: Label = $Help/GameMessage

func _ready() -> void:
    player.health_changed.connect(_update_hud)
    player.player_defeated.connect(_on_player_defeated)
    for insect in get_tree().get_nodes_in_group("insects"):
        _connect_insect(insect)
    _update_hud(player.health)

func _connect_insect(insect: Node) -> void:
    if insect.has_signal("defeated"):
        insect.defeated.connect(_on_insect_defeated)

func _on_insect_defeated(points: int) -> void:
    score += points
    _update_hud(player.health)
    if score >= 500 and not game_over:
        game_over = true
        message.text = "CHAMP PROTEGE ! Appuie sur R pour rejouer"
        message.visible = true

func _update_hud(remaining: int) -> void:
    hud.text = "Vies : %d / 3     Score : %d / 500" % [remaining, score]

func _on_player_defeated() -> void:
    game_over = true
    message.text = "PARTIE PERDUE ! Appuie sur R pour rejouer"
    message.visible = true
    player.set_physics_process(false)
    player.get_node("StateMachine").set_physics_process(false)

func _unhandled_input(event: InputEvent) -> void:
    if game_over and event.is_action_pressed("restart"):
        get_tree().reload_current_scene()
