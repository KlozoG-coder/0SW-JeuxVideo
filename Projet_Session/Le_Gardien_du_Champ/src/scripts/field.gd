extends Node2D

# Terrain du village : terre rouge, herbe, pierres et cultures.
func _draw() -> void:
    var soil := Color("#ad603e")
    draw_rect(Rect2(0, 180, 2400, 120), soil)
    draw_rect(Rect2(0, 180, 2400, 9), Color("#5b9949"))
    for x in range(0, 2400, 38):
        var y: float = 203.0 + float((x / 38) % 4) * 15.0
        draw_rect(Rect2(x + 4, y, 13, 3), Color("#87452f"))
        draw_rect(Rect2(x + 20, y + 13, 6, 3), Color("#d98955"))
    for x in range(85, 2380, 98):
        draw_line(Vector2(x, 180), Vector2(x, 147), Color("#3f803b"), 3.0)
        draw_circle(Vector2(x - 7, 158), 7.0, Color("#5fae47"))
        draw_circle(Vector2(x + 8, 153), 7.0, Color("#75bd4e"))
        draw_circle(Vector2(x, 142), 6.0, Color("#9ac858"))
