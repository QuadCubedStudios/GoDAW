extends WindowDialog

signal sequence_song(sequence)


#
#func _popup(name):
#	if script_editor.text == "":
#		script_editor.text = BASE_SONG_SCRIPT % name
#	script_editor.clear_undo_history()
##	data.name = name
##	data.id = id
#	popup_centered()
#	script_editor.cursor_set_column(0)
#	script_editor.cursor_set_line(0)
#	script_editor.grab_focus()
#
#func _unpopup():
#	var file =  File.new()
#	file.open("res://song.gd", File.WRITE)
#	file.store_string(script_editor.text)
#	file.close()
#	var song: SongScript = load("res://song.gd").new()
#	song.entry()
#	emit_signal("sequence_song", song.sequence)
