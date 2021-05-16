extends Panel

var text: String setget set_text
var icon: Resource setget set_icon
var disabled: bool = false
var pressed = preload("res://Theme/Default/SongButtonPressed.tres")
var song_editor_entry_scn = preload("res://Panels/SongEditor/SongEditorEntry.tscn")

func init(ico: Resource, instrument_name: String, enabled: bool = true):
	set_text(instrument_name)
	set_icon(ico)
	disabled = !enabled

func _on_Instrument_gui_input(event):
	if event is InputEventMouseButton and !disabled:
		if event.pressed and event.button_index == 1:
			var song_editor_entry = song_editor_entry_scn.instance()
			song_editor_entry.init(text, icon)
			Global.song_editor.get_node("VBox").add_child(song_editor_entry)

func set_text(val: String):
	text = val
	$HBox/Label.text = val

func set_icon(val: Resource):
	icon = val
	$HBox/TextureRect.set_texture(val)
