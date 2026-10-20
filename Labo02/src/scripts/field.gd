extends Node2D

# Décor minimal : sol et rangées de cultures, sans menu ni système de score.
func _draw() -> void:
    draw_rect(Rect2(0, 180, 2400, 110), Color("#775331"))
    draw_rect(Rect2(0, 180, 2400, 10), Color("#6eaa4b"))
    for x in range(80, 2370, 88):
        draw_line(Vector2(x, 181), Vector2(x, 161), Color("#386e37"), 3.0)
        draw_circle(Vector2(x - 5, 166), 7.0, Color("#72b84b"))
        draw_circle(Vector2(x + 6, 163), 7.0, Color("#5a9d3c"))
        draw_circle(Vector2(x, 156), 5.0, Color("#83c55a"))
    for x in range(0, 2400, 45):
        draw_line(Vector2(x, 212), Vector2(x + 24, 212), Color("#94683c"), 2.0)
