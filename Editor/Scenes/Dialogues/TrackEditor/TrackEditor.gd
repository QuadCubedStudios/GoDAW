extends WindowDialog

onready var script_editor = $HBoxContainer/TextEdit

const BASE_SONG_SCRIPT = """extends SongScript

func entry():
	track("%s", [
		# Place your notes here
	])
	pass"""

var data = {
	"name": "String",
	"id": null,
}

func _popup(name, id):
	if script_editor.text == "":
		script_editor.text = BASE_SONG_SCRIPT % name
	script_editor.clear_undo_history()
	data.name = name
	data.id = id
	popup_centered()
	script_editor.cursor_set_column(0)
	script_editor.cursor_set_line(0)
	script_editor.grab_focus()

func _unpopup():
	var file =  File.new()
	file.open("res://song.gd", File.WRITE)
	file.store_string(script_editor.text)
	file.close()
	var song: SongScript = load("res://song.gd").new()
	song.entry()
	get_parent().get_parent().sequencer.sequence(song.sequence)
