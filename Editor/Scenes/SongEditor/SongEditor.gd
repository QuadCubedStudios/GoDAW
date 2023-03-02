extends VBoxContainer

# Signals
signal playback_finished()
signal start_loading()
signal stop_loading()
signal done_error_handling(done)
signal done_error_check(error)
signal song_script_error(error)
signal track_pressed (name)

onready var SCRIPT_LOCATION = OS.get_user_data_dir() + "/song.gd"
onready var BIN = OS.get_executable_path()
var ERROR_REGEX = RegEx.new()
const SONG_PATH = "user://song.gd"

const BASE_SONG_SCRIPT = """extends SongScript


func song():
	track("%s", [
		# Place your notes here
	])
	pass"""

var gui: bool = true
var track_name = preload("./TrackName.tscn")
var error_text = ""
var in_file = ""
var song_file: File

onready var thread = Thread.new()
onready var names = $TracksScroll/HBox/Names
onready var song_script_editor = $SongScriptEditor
onready var track_scroll = $TracksScroll
onready var sequencer = $Sequencer
onready var instrument_container = $InstrumentContainer

func _ready():
	ERROR_REGEX.compile("SCRIPT ERROR: (.*?)\\n(?:.*?):([0-9]+)")
	song_file = File.new()
	connect("done_error_check", self, "_after_error_check")

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

func check_error():
	# Error check
	var err = []
	var _n = OS.execute(BIN, ["-s", SCRIPT_LOCATION, "--check-only", "--no-window"], true, err, true)
	var error = ""
	var regex_result = ERROR_REGEX.search(err[0])
	if regex_result:
		var regex_out = ERROR_REGEX.search(err[0]).get_strings()
		error = "%s at SongScript:%s" % [regex_out[1], regex_out[2]]
	emit_signal("done_error_check", error)

func _after_error_check(error):
	emit_signal("stop_loading")
	error_text = error
	if error:
		emit_signal("song_script_error", error_text)
		return false

	error_text = ""
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
	emit_signal("done_error_handling")

# Return true if everything goes alright
func sequence():
	if !gui:
		emit_signal("start_loading")
		if in_file != song_script_editor.text:
			song_file.open(SONG_PATH, File.WRITE_READ)
			song_file.store_string(song_script_editor.text)
			song_file.close()
			in_file = song_script_editor.text
			thread.start(self, "check_error")

func _on_play():
	sequence()
	yield(self, "done_error_handling")
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
