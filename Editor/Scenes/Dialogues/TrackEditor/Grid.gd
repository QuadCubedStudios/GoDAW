extends Node2D

const track_editor_script = preload("res://Editor/Scenes/Dialogues/TrackEditor/TrackEditor.gd")
export var thickness = 2
export var color: Color
export var border_color: Color

export var track_editor_path: NodePath

func _draw():
	var grid_size = get_parent().rect_size
	var track_editor: track_editor_script = get_node(track_editor_path)
	var size: int = track_editor.note_names.get_child(0).rect_size.y
	var name_size = track_editor.name_scroll.rect_size.x
	var xoffset = track_editor.scroll.scroll_horizontal % size - get_parent().get_constant("separation")
	var yoffset = track_editor.scroll.scroll_vertical % size
		
	# Grid in y direction
	for y in grid_size.y/size:
		if y*size-yoffset >= 0:
			draw_line(Vector2(0, y*size - yoffset), Vector2(grid_size.x, y*size - yoffset), color, thickness)
			draw_line(Vector2(0, y*size - yoffset), Vector2(name_size, y*size - yoffset), border_color, thickness*2)
	
	# Grid in x direction
	for x in grid_size.x/size - name_size/size:
		if x*size + name_size - xoffset > track_editor.name_scroll.rect_size.x:
			draw_line(Vector2(x*size + name_size - xoffset, 0), Vector2(x*size + name_size-xoffset, grid_size.y), color, thickness)

	draw_line(Vector2.ZERO, Vector2(0, grid_size.y), border_color, thickness*2)
	draw_line(Vector2(name_size, 0), Vector2(name_size, grid_size.y), border_color, thickness*2)
