extends Node

onready var script_editor = get_parent()

func keyword(keyword: String):
	script_editor.add_keyword_color(keyword, Color("e8a2af"))

func region(start: String, end: String, color: Color, line_only: bool = false):
	script_editor.add_color_region(start, end, color, line_only)

func type(type_name: String):
	script_editor.add_keyword_color(type_name, Color("fae3b0"))

func _ready():
	keyword("extends")
	keyword("func")
	keyword("onready")
	keyword("var")
	keyword("const")
	keyword("pass")
	type("SongScript")
	region('"', '"', Color("abe9b3"))
	region("'", "'", Color("abe9b3"))
	region("#", "\n", Color("6e6c7e"), true)
	pass
