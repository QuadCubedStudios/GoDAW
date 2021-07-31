extends Control

onready var loading_dialog: WindowDialog = $DialogBoxes/LoadingDialog
onready var loading_dialog_progress: ProgressBar = $DialogBoxes/LoadingDialog/VBoxContainer/ProgressBar

func load_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")
	dir.list_dir_begin(true, true)

	var instruments = []

	var instrument_name = dir.get_next()
	while instrument_name != "":
		if dir.file_exists("./%s/Instrument.tscn" % instrument_name):
			instruments.append(instrument_name)
		else:
			push_warning("Instrument %s does not have an Instrument.tscn file" % instrument_name)

		instrument_name = dir.get_next()

	loading_dialog_progress.max_value = instruments.size()

	for name in instruments:
		$DialogBoxes/LoadingDialog/VBoxContainer/Label.text = name

		yield(get_tree(), "idle_frame")
		var instrument: PackedScene = load("%s/%s/Instrument.tscn" % [dir.get_current_dir(), name])
		GoDAW.register_instrument(name, instrument)
		loading_dialog_progress.value += 1

	loading_dialog.hide()

# This function is solely testing code
func _ready():
	loading_dialog.popup()

	yield(load_instruments(), "completed")

	var song = SongSequence.new()
	var track = Track.new()
	track.instrument = "DTMF"
	song.add_track(track)
	var i = 0.0
	# Number taken from https://en.wikipedia.org/wiki/Fictitious_telephone_number
	for key in "1800160401":
		var note = Note.new()
		note.duration = 0.3
		note.note_start = i
		note.instrument_data = key
		track.add_note(note)
		i += 0.3

	$Application/Main/SongEditor/Sequencer.sequence(song)
