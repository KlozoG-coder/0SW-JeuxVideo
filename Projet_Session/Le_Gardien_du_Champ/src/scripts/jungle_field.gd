extends Node2D

func _draw() -> void:
    draw_rect(Rect2(0, 184, 2400, 160), Color("#493a30"))
    draw_rect(Rect2(0, 184, 2400, 9), Color("#366f45"))
    for x in range(0, 2400, 54):
        draw_rect(Rect2(x + 7, 220 + (x / 54 % 3) * 14, 24, 4), Color("#6d5140"))
        draw_line(Vector2(x + 20, 184), Vector2(x + 5, 170), Color("#428650"), 3.0)
        draw_line(Vector2(x + 20, 184), Vector2(x + 35, 165), Color("#387547"), 3.0)
    for x in range(50, 2400, 150):
        draw_line(Vector2(x, 184), Vector2(x, 146), Color("#366a3e"), 4.0)
        draw_circle(Vector2(x, 146), 12, Color("#5f9a43"))
