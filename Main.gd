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
	var track2 = Track.new()
	track.instrument = "Square"
	track2.instrument = "Square"
	song.add_track(track)
	song.add_track(track2)
	for i in range(12):
		var n = Note.new()
		n.duration = 0.8
		n.note_start = i
		n.instrument_data = {
			"key": 59+i
		}
		var n2 = Note.new()
		n2.duration = 0.4
		n2.note_start = i+0.4
		n2.instrument_data = {
			"key": 70+i
		}
		track.add_note(n)
		track2.add_note(n2)
		pass
	var seq = Sequencer.new()
	add_child(seq)
	seq.sequence(song)
