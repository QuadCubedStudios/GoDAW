extends Control

onready var track_editor = $TrackEditor
onready var script_editor = $TrackEditor.script_editor
onready var sequencer = $Sequencer
onready var instruments = $Instruments

func _ready():
	track_editor._popup("Square")
	track_editor.get_close_button().hide()
	GoDAW.load_instruments()
	pass


func _on_ControlPanel_play():
	var file =  File.new()
	file.open("res://song.gd", File.WRITE)
	file.store_string(script_editor.text)
	file.close()
	var song: SongScript = load("res://song.gd").new()
	song.entry()
	if song.sequence.tracks.size() != instruments.get_child_count():
		sequencer.INSTRUMENTS.clear()
		for instrument in instruments.get_children():
			instrument.queue_free()
		for track in song.sequence.tracks:
			var inst = GoDAW.get_instrument(track.instrument)
			sequencer.INSTRUMENTS[track.instrument] = inst
			instruments.add_child(inst)
	sequencer.sequence(song.sequence)
	sequencer.play()
