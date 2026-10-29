extends Node2D

# Decor du champ : terre rouge, herbe, sillons et plants de mais.
const FIELD_LENGTH: int = 2400

func _draw() -> void:
    draw_rect(Rect2(0, 184, FIELD_LENGTH, 160), Color("#a75b3b"))
    draw_rect(Rect2(0, 184, FIELD_LENGTH, 8), Color("#68a34b"))
    draw_rect(Rect2(0, 191, FIELD_LENGTH, 7), Color("#805039"))
    for x in range(0, FIELD_LENGTH, 42):
        draw_rect(Rect2(x + 6, 215 + (x / 42 % 3) * 12, 17, 4), Color("#85452f"))
        draw_rect(Rect2(x + 25, 242 + (x / 42 % 4) * 9, 8, 3), Color("#c98152"))
    for x in range(85, FIELD_LENGTH - 40, 116):
        _draw_crop(Vector2(x, 184))
    for x in range(30, FIELD_LENGTH, 270):
        draw_line(Vector2(x, 179), Vector2(x, 147), Color("#815432"), 4.0)
        draw_line(Vector2(x + 110, 179), Vector2(x + 110, 147), Color("#815432"), 4.0)
        draw_line(Vector2(x, 153), Vector2(x + 110, 153), Color("#ad8050"), 3.0)

func _draw_crop(p: Vector2) -> void:
    draw_line(p, p + Vector2(0, -34), Color("#39743c"), 3.0)
    draw_colored_polygon(PackedVector2Array([p + Vector2(0, -16), p + Vector2(-17, -28), p + Vector2(-10, -11)]), Color("#5b9c43"))
    draw_colored_polygon(PackedVector2Array([p + Vector2(0, -23), p + Vector2(16, -33), p + Vector2(11, -15)]), Color("#78ae49"))
    draw_rect(Rect2(p + Vector2(-3, -32), Vector2(6, 12)), Color("#e7c15d"))
