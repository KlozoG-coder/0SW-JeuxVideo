extends Node

var music_player: AudioStreamPlayer
var sfx_player: AudioStreamPlayer
var muted: bool = false

func _ready() -> void:
    _ensure_bus("Music")
    _ensure_bus("SFX")
    music_player = AudioStreamPlayer.new()
    music_player.bus = "Music"
    add_child(music_player)
    sfx_player = AudioStreamPlayer.new()
    sfx_player.bus = "SFX"
    add_child(sfx_player)
    var stream := load("res://assets/music_loop.wav") as AudioStreamWAV
    if stream:
        stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
        music_player.stream = stream
        music_player.play()
    load_settings()

func _ensure_bus(bus_name: String) -> void:
    if AudioServer.get_bus_index(bus_name) == -1:
        AudioServer.add_bus()
        AudioServer.set_bus_name(AudioServer.bus_count - 1, bus_name)

func play_sfx(name: String) -> void:
    var stream := load("res://assets/%s.wav" % name)
    if stream:
        var player := AudioStreamPlayer.new()
        player.bus = "SFX"
        player.stream = stream
        add_child(player)
        player.finished.connect(player.queue_free)
        player.play()

func set_volume(bus_name: String, value: float) -> void:
    var index := AudioServer.get_bus_index(bus_name)
    if index >= 0:
        AudioServer.set_bus_volume_db(index, linear_to_db(maxf(value, 0.0001)))
        AudioServer.set_bus_mute(index, value <= 0.001)
    save_settings()

func get_volume(bus_name: String) -> float:
    var index := AudioServer.get_bus_index(bus_name)
    if index < 0: return 1.0
    if AudioServer.is_bus_mute(index): return 0.0
    return db_to_linear(AudioServer.get_bus_volume_db(index))

func toggle_mute() -> void:
    muted = not muted
    AudioServer.set_bus_mute(0, muted)

func _unhandled_key_input(event: InputEvent) -> void:
    if event is InputEventKey and event.pressed and not event.echo and event.ctrl_pressed and event.keycode == KEY_M:
        toggle_mute()
        get_viewport().set_input_as_handled()

func save_settings() -> void:
    var cfg := ConfigFile.new()
    cfg.set_value("audio", "music", get_volume("Music"))
    cfg.set_value("audio", "sfx", get_volume("SFX"))
    cfg.save("user://settings.cfg")

func load_settings() -> void:
    var cfg := ConfigFile.new()
    if cfg.load("user://settings.cfg") == OK:
        set_volume("Music", float(cfg.get_value("audio", "music", 0.65)))
        set_volume("SFX", float(cfg.get_value("audio", "sfx", 0.85)))
    else:
        set_volume("Music", 0.65)
        set_volume("SFX", 0.85)
