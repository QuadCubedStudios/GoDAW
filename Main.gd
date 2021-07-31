extends Control

func load_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")
	dir.list_dir_begin(true, true)

	var instrument_name = dir.get_next()
	while instrument_name != "":
		if dir.file_exists("./%s/Instrument.tscn" % instrument_name):
			var instrument: PackedScene = load("%s/%s/Instrument.tscn" % [dir.get_current_dir(), instrument_name])
			GoDAW.register_instrument(instrument_name, instrument)
		else:
			push_warning("Instrument %s does not have an Instrument.tscn file" % instrument_name)

		instrument_name = dir.get_next()

func _init():
	load_instruments()

# This function is solely testing code
func _ready():
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
