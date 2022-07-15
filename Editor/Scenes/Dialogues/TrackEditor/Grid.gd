extends Node2D

var size: int = 25
var thickness = 2
onready var track_editor = $"../../../"

func _draw():
	draw_line(Vector2(0, 0), Vector2(0, get_parent().rect_size.y), Color("#9191aa"), thickness)
	for y in get_parent().rect_size.y/size:
		if y*size-track_editor.scroll.scroll_vertical % size > 0:
			draw_line(Vector2(0, y*size-track_editor.scroll.scroll_vertical % size), Vector2(get_parent().rect_size.x, y*size-track_editor.scroll.scroll_vertical % size), Color("#9191aa"), thickness)
	for x in get_parent().rect_size.x/size - track_editor.name_scroll.rect_size.x/size:
		if x*size+track_editor.name_scroll.rect_size.x-track_editor.scroll.scroll_horizontal % size > track_editor.name_scroll.rect_size.x:
			draw_line(Vector2(x*size+track_editor.name_scroll.rect_size.x-track_editor.scroll.scroll_horizontal % size, 0), Vector2(x*size+track_editor.name_scroll.rect_size.x-track_editor.scroll.scroll_horizontal % size, get_parent().rect_size.y), Color("#9191aa"), thickness)
