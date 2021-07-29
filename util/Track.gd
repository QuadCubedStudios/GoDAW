class_name Track extends Reference

var notes: Array = []
var instrument: String

func add_note(note: Note):
	notes.append(note)
