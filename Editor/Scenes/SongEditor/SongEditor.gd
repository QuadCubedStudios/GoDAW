extends VBoxContainer

# Signals
signal playback_finished()
signal track_pressed (name)

const BASE_SONG_SCRIPT = """extends SongScript

func song():
	track("%s", [
		# Place your notes here
	])
	pass"""

var gui: bool = true
var track_name = preload("./TrackName.tscn")

onready var names = $TracksScroll/HBox/Names
onready var song_script_editor = $SongScriptEditor
onready var track_scroll = $TracksScroll
onready var sequencer = $Sequencer
onready var instrument_container = $InstrumentContainer

# Takes a Button since it conveniently sends an icon and message
# TODO: Not use button as param
func add_track(instrument: Button):
	if !gui: return
	var name = track_name.instance()
	name.set_instrument(instrument.icon, instrument.text)
	names.add_child(name)
	name.connect("pressed", self, "emit_signal", ["track_pressed", instrument.text])
	
	# TODO: Hacky code
	var inst := GoDAW.get_instrument(instrument.text)
	$Sequencer.INSTRUMENTS[instrument.text] = inst

func sequence():
	if !gui:
		var file =  File.new()
		var dir = Directory.new()
		file.open("res://song.gd", File.WRITE)
		file.store_string(song_script_editor.text)
		file.close()
		var song: SongScript = load("res://song.gd").new()
		song.entry()
		if song.sequence.tracks.size() != instrument_container.get_child_count():
			sequencer.INSTRUMENTS.clear()
			for instrument in instrument_container.get_children():
				instrument.queue_free()
			for track in song.sequence.tracks:
				var inst = GoDAW.get_instrument(track.instrument)
				sequencer.INSTRUMENTS[track.instrument] = inst
				instrument_container.add_child(inst)
		sequencer.sequence(song.sequence)

func _on_play():
	sequence()
	sequencer.play()

func _on_pause():
	sequencer.pause()

func _on_stop():
	sequencer.stop()

func _on_Sequencer_playback_finished():
	emit_signal("playback_finished")


func _on_TrackEditor_sequence_song(sequence):
	sequencer.sequence(sequence)


func project_changed(project: Project):
	gui = true if project.project_type == Project.PROJECT_TYPE.GUI else false
	song_script_editor.visible = !gui
	track_scroll.visible = gui
	for name in names.get_children():
		name.queue_free()
	song_script_editor.text = BASE_SONG_SCRIPT % "Square"
