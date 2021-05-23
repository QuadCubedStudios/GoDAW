extends Control

var scroll = 0 setget set_scroll


func _ready():
	Global.connect("window_size_changed", self, "fix_cells")
	fix_cells(OS.window_size)

func fix_cells(_window_size):
	update()

func set_scroll(val):
	scroll += val
	update()

func _draw():
	for x in range(OS.window_size.x-300):
		draw_line(Vector2(90+x*14, 0), Vector2(90+x*14, get_node("../../../").rect_size.y),
		Color("1f1c24"), 1)
	for y in range(get_node("../../../").rect_size.y/14):
		draw_line(Vector2(90, y*14), Vector2(90+OS.window_size.x, y*14), Color("1f1c24"), 1)
	var first = true
	for x in range(OS.window_size.x-300):
		if first:
			first = false
			continue
		draw_line(Vector2(90+x*14*4, 0), Vector2(90+x*14*4, get_node("../../../").rect_size.y),
		Color("1f1c24"), 4)
	for y in range(get_node("../../../").rect_size.y/14*13):
		draw_line(Vector2(90, y*14*12+14*scroll),
		Vector2(90+OS.window_size.x, y*14*12+14*scroll), Color("1f1c24"), 4)
#		print(y*SIZE*13+SIZE*scroll)
