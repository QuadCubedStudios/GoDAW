extends VBoxContainer

# Signals
signal playback_finished()
signal song_script_error(error)
signal track_pressed (name)

onready var BIN = OS.get_executable_path()
const BASE_SONG_SCRIPT = """extends SongScript


func song():
	track("%s", [
		# Place your notes here
	])
	pass"""

var gui: bool = true
var track_name = preload("./TrackName.tscn")
var in_error: bool = false
var error_text = ""
var in_file = ""
var song_file: File

onready var names = $TracksScroll/HBox/Names
onready var song_script_editor = $SongScriptEditor
onready var track_scroll = $TracksScroll
onready var sequencer = $Sequencer
onready var instrument_container = $InstrumentContainer

func _ready():
	song_file = File.new()
	song_file.open("user://song.gd", File.WRITE_READ)

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

func check_error(script_location: String) -> String:
	# Error check
	var err = []
	var _n = OS.execute(BIN, ["-s", script_location, "--check-only", "--no-window"], true, err, true)
	var error = (err[0] as String).substr(err[0].find("SCRIPT"))\
		.replace(script_location, "SongScript")\
		.replace(" (", "")\
		.replace("SCRIPT ERROR: ", "")\
		.replace("GDScript::reload", "")
	var prev = 0
	for i in error.count("SongScript:"):
		prev = error.find(")", error.find("SongScript"))
		error[prev] = ""
	return error

# Return true if everything goes alright
func sequence() -> bool:
	if !gui:
		var file =  File.new()
		file.open("user://song.gd", File.WRITE_READ)
		if in_file != song_script_editor.text:
			file.store_string(song_script_editor.text)
#			yield(get_tree(), "idle_frame")
			in_file = file.get_as_text() # Idk why but the file isn't storing without this Wierd
			var script_location = OS.get_user_data_dir() + "/song.gd"
			error_text = check_error(script_location)
			print(error_text)
			in_error = error_text as bool
		file.close()
		
		if in_error:
			emit_signal("song_script_error", error_text)
			return false
		
		var song: SongScript = load("user://song.gd").new()
		if !song.has_method("song"):
			emit_signal("song_script_error", "Script has no song method")
			return false
		song.sequence.tracks.clear()
		song.song()
		if song.sequence.tracks.size() != instrument_container.get_child_count():
			sequencer.INSTRUMENTS.clear()
			for instrument in instrument_container.get_children():
				instrument.queue_free()
			for track in song.sequence.tracks:
				var inst = GoDAW.get_instrument(track.instrument)
				sequencer.INSTRUMENTS[track.instrument] = inst
				instrument_container.add_child(inst)
		sequencer.sequence(song.sequence)
	return true

func _on_play():
	if sequence():
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
	if project.song_script:
		song_script_editor.text = project.song_script
	else:
		song_script_editor.text = BASE_SONG_SCRIPT % "Square"
