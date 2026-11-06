extends Node2D

@export var level_number: int = 1
@export var next_level_path: String = "res://scenes/Level2.tscn"
@export var starting_crop_health: int = 100

var score: int = 0
var crop_health: int = 100
var game_over: bool = false
var finished_enemies: int = 0
var total_enemies: int = 0
var checkpoint: Vector2 = Vector2(145, 142)
var saved_best: int = 0

# Les insectes initiaux forment la première vague. Deux vagues
# supplémentaires sont générées avant la fin de chaque niveau.
const INSECT_SCENE: PackedScene = preload("res://scenes/Insect.tscn")
const MAX_WAVES: int = 3
var director: WaveDirector = WaveDirector.new()
var wave_number: int = 1
var wave_started_at: float = 0.0
var spawning: bool = false
var spawn_remaining: int = 0
var spawn_cooldown: float = 0.0
var current_wave_config: Dictionary = {}


@onready var player: Player = $Player
@onready var hud: Label = $Help/Status
@onready var message: Label = $Help/GameMessage

func _ready() -> void:
    crop_health = starting_crop_health
    player.health_changed.connect(_update_hud)
    player.player_defeated.connect(_on_player_defeated)
    for insect in get_tree().get_nodes_in_group("insects"):
        total_enemies += 1
        insect.defeated.connect(_on_insect_defeated)
    $CropZone.crop_damaged.connect(_on_crop_damaged)
    _load_best()
    wave_started_at = Time.get_ticks_msec() / 1000.0
    _update_hud(player.health)

func _physics_process(delta: float) -> void:
    if game_over:
        return
    if spawning:
        spawn_cooldown -= delta
        if spawn_remaining > 0 and spawn_cooldown <= 0.0:
            _spawn_insect()
            spawn_remaining -= 1
            spawn_cooldown = float(current_wave_config["spawn_interval"])
        if spawn_remaining == 0:
            spawning = false
    if player.global_position.y > 380.0:
        player.take_damage()
        player.global_position = checkpoint
        player.velocity = Vector2.ZERO
    if player.global_position.x > 1200.0:
        checkpoint = Vector2(1180, 142)
    if not spawning and finished_enemies >= total_enemies and total_enemies > 0:
        if wave_number < MAX_WAVES:
            _start_next_wave()
        else:
            _complete_level()


func _start_next_wave() -> void:
    var duration: float = Time.get_ticks_msec() / 1000.0 - wave_started_at
    director.register_wave_result(player.health, crop_health, duration)
    current_wave_config = director.next_wave(level_number)
    wave_number += 1
    spawn_remaining = int(current_wave_config["count"])
    total_enemies += spawn_remaining
    spawn_cooldown = 0.0
    spawning = true
    wave_started_at = Time.get_ticks_msec() / 1000.0
    message.text = "VAGUE %d : LES INSECTES ARRIVENT !" % wave_number
    message.visible = true
    _update_hud(player.health)

func _spawn_insect() -> void:
    var insect := INSECT_SCENE.instantiate()
    # Spawn à proximité de la zone visible du joueur, dans les limites du niveau.
    var offset: float = 290.0 if spawn_remaining % 2 == 0 else -290.0
    var spawn_x: float = clampf(player.global_position.x + offset, 280.0, 2180.0)
    insect.position = Vector2(spawn_x, 154.0)
    insect.speed_multiplier = float(current_wave_config["speed_multiplier"])
    add_child(insect)
    insect.defeated.connect(_on_insect_defeated)
    if spawn_remaining == 1:
        message.visible = false

func _on_insect_defeated(points: int) -> void:
    if game_over:
        return
    finished_enemies += 1
    score += points
    AudioManager.play_sfx("enemy")
    _update_hud(player.health)

func _on_crop_damaged(amount: int) -> void:
    if game_over:
        return
    crop_health = maxi(0, crop_health - amount)
    _update_hud(player.health)
    if crop_health == 0:
        _finish(false, "LES CULTURES SONT DETRUITES !")

func _update_hud(remaining: int) -> void:
    hud.text = "Niveau : %d  Vague : %d/%d  Vies : %d/3  Cultures : %d%%  Score : %d  Record : %d" % [level_number, wave_number, MAX_WAVES, remaining, crop_health, score, saved_best]

func _on_player_defeated() -> void:
    _finish(false, "LE FERMIER A PERDU TOUTES SES VIES !")

func _complete_level() -> void:
    if level_number == 1:
        game_over = true
        _save_best()
        message.text = "NIVEAU 1 TERMINE ! Appuie sur ENTREE pour le niveau 2"
        message.visible = true
    else:
        _finish(true, "BRAVO ! LE VILLAGE EST SAUVE !")

func _finish(won: bool, description: String) -> void:
    game_over = true
    _save_best()
    message.text = description + ("  |  R : Rejouer" if not won else "  |  R : Rejouer")
    message.visible = true
    player.set_physics_process(false)
    player.get_node("StateMachine").set_physics_process(false)

func _unhandled_input(event: InputEvent) -> void:
    if not game_over:
        return
    if event.is_action_pressed("restart"):
        get_tree().reload_current_scene()
    elif level_number == 1 and event.is_action_pressed("ui_accept") and finished_enemies >= total_enemies:
        get_tree().change_scene_to_file(next_level_path)

func _load_best() -> void:
    if FileAccess.file_exists("user://record.txt"):
        var file := FileAccess.open("user://record.txt", FileAccess.READ)
        if file != null:
            saved_best = int(file.get_as_text().strip_edges())

func _save_best() -> void:
    if score > saved_best:
        saved_best = score
        var file := FileAccess.open("user://record.txt", FileAccess.WRITE)
        if file != null:
            file.store_string(str(saved_best))
    _update_hud(player.health)
