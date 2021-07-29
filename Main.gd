extends Control

export var pattern: Resource = preload("res://Patterns/pattern1.tres")

var bpm = 140
var time := 0.0 # timeline position, not system time

func load_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")
	dir.list_dir_begin(true, true)

	var instrument_name = dir.get_next()
	while instrument_name != "":
		if dir.file_exists("./%s/Instrument.tscn" % instrument_name):
			var instrument: PackedScene = load("%s/%s/Instrument.tscn" % [dir.get_current_dir(), instrument_name])
			GoDAW.register_instrument(instrument_name, instrument.instance())
		else:
			push_warning("Instrument %s does not have an Instrument.tscn file" % instrument_name)

		instrument_name = dir.get_next()

func _init():
	load_instruments()

func _ready():
	Global.connect("play", self, "play")

func play():
	var song = SongSequence.new()
	var track = Track.new()
	track.instrument = "Square"
	song.add_track(track)
	for i in range(12):
		var n = Note.new()
		n.duration = 0.8
		n.note_start = i
		n.instrument_data = {
			"key": 59+i
		}
		track.add_note(n)
		pass
	var seq = Sequencer.new()
	seq.data = song
	add_child(seq)
	seq.play()
#	var inst = GoDAW.get_instrument("Square")
#	add_child(inst)
#	var note = {
#		"duration": 0.2,
#		"instrument_data": { "key": 59 }
#	}
#	inst.play_note(note)
