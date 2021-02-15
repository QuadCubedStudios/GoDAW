extends Node2D


func _ready():
	var ptn = GDW_pattern.new()
	generate_pattern(ptn)
	ResourceSaver.save("res://Patterns/pattern1.tres", ptn)


func generate_pattern(p:GDW_pattern):
	# This melody is of course highly copyrighted, nobody can use it
	# (kidding)
	p.length = 4.0
	p.add_note(64, 0.0)
	p.add_note(68, 1.5)
	p.add_noteoff(64, 0.7)
	p.add_noteoff(68, 2.5)
	p.add_note(71, 3.0)
	p.add_noteoff(71, 3.5)
	p.sort_notes()
	print(p.data)
