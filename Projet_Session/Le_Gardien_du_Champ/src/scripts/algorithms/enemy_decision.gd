class_name EnemyDecision
extends RefCounted

# Algorithme 1 : choix d'un comportement en fonction de la distance,
# de la position de la cible et du temps depuis la dernière détection.
enum Mode { PATROL, CHASE, RETREAT }

var mode: Mode = Mode.PATROL
var memory_left: float = 0.0
var last_seen_x: float = 0.0

func decide(delta: float, enemy_x: float, home_x: float, target_x: float, target_y: float, enemy_y: float, detection: float, patrol_range: float, health_ratio: float) -> float:
    var dx: float = target_x - enemy_x
    var dy: float = absf(target_y - enemy_y)
    var sees_target: bool = absf(dx) <= detection and dy <= 105.0
    if sees_target:
        last_seen_x = target_x
        memory_left = 1.6
    else:
        memory_left = maxf(0.0, memory_left - delta)

    if health_ratio <= 0.34 and sees_target and absf(dx) < 70.0:
        mode = Mode.RETREAT
    elif sees_target or memory_left > 0.0:
        mode = Mode.CHASE
    else:
        mode = Mode.PATROL

    match mode:
        Mode.RETREAT:
            return -1.0 if dx > 0.0 else 1.0
        Mode.CHASE:
            var destination: float = target_x if sees_target else last_seen_x
            if absf(destination - enemy_x) < 8.0:
                return 0.0
            return 1.0 if destination > enemy_x else -1.0
        _:
            if enemy_x > home_x + patrol_range:
                return -1.0
            if enemy_x < home_x - patrol_range:
                return 1.0
            return 0.0 # Conserver la direction de patrouille précédente
