extends StaticBody2D

@export var platform_width: float = 145.0

func _draw() -> void:
    var half_width: float = platform_width / 2.0
    draw_rect(Rect2(-half_width, -8, platform_width, 17), Color("#825137"))
    draw_rect(Rect2(-half_width, -8, platform_width, 5), Color("#d49b5a"))
    for x in range(int(-half_width) + 14, int(half_width), 29):
        draw_line(Vector2(x, -4), Vector2(x, 7), Color("#5f3d2d"), 2.0)
    draw_line(Vector2(-half_width, 9), Vector2(half_width, 9), Color("#513529"), 2.0)
