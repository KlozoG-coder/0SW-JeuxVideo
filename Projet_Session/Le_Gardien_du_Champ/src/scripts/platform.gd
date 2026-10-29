extends StaticBody2D

@export var platform_width: float = 145.0

func _draw() -> void:
    var half_width: float = platform_width / 2.0
    # Poutres, planches et contour visibles sur le fond du village.
    draw_rect(Rect2(-half_width + 13, 7, 8, 24), Color("#6b422b"))
    draw_rect(Rect2(half_width - 21, 7, 8, 24), Color("#6b422b"))
    draw_rect(Rect2(-half_width, -9, platform_width, 18), Color("#69412b"))
    draw_rect(Rect2(-half_width, -9, platform_width, 6), Color("#d4a16a"))
    draw_rect(Rect2(-half_width + 3, -2, platform_width - 6, 7), Color("#98623e"))
    for x in range(int(-half_width) + 17, int(half_width), 28):
        draw_line(Vector2(x, -8), Vector2(x, 7), Color("#5b3a2c"), 2.0)
        draw_circle(Vector2(x + 7, 1), 1.5, Color("#e0b47c"))
