class_name WaveDirector
extends RefCounted

# Algorithme 2 : adapte la taille, la vitesse et le délai des vagues
# aux performances récentes du joueur, avec des bornes de sécurité.
var wave_index: int = 0
var performance: float = 0.5

func register_wave_result(remaining_lives: int, crop_health: int, elapsed_seconds: float) -> void:
    var survival: float = clampf(float(remaining_lives) / 3.0, 0.0, 1.0)
    var harvest: float = clampf(float(crop_health) / 100.0, 0.0, 1.0)
    var speed: float = clampf(45.0 / maxf(elapsed_seconds, 1.0), 0.0, 1.0)
    var observed: float = 0.4 * survival + 0.4 * harvest + 0.2 * speed
    performance = clampf(performance * 0.45 + observed * 0.55, 0.0, 1.0)

func next_wave(level_number: int) -> Dictionary:
    wave_index += 1
    var difficulty: float = float(level_number - 1) + float(wave_index - 1) * 0.6 + performance
    return {
        "count": clampi(2 + int(floor(difficulty * 1.6)), 2, 7),
        "speed_multiplier": clampf(1.0 + difficulty * 0.12, 1.0, 1.8),
        "spawn_interval": clampf(1.2 - difficulty * 0.12, 0.45, 1.2)
    }
