extends LiveSynthesisInstrument

# Taken from the DTMF Wikipedia article
const FREQ_ROWS := [697, 770, 852, 941]
const FREQ_COLS := [1209, 1336, 1477, 1633]
const KEYS := {
	"1": [0, 0],
	"2": [0, 1],
	"3": [0, 2],
	"A": [0, 3],

	"4": [1, 0],
	"5": [1, 1],
	"6": [1, 2],
	"B": [1, 3],

	"7": [2, 0],
	"8": [2, 1],
	"9": [2, 2],
	"C": [2, 3],

	"*": [3, 0],
	"0": [3, 1],
	"#": [3, 2],
	"D": [3, 3],
}

var current_key := ""

func _init().("DTMF"):
	pass

func waveform(t: float) -> float:
	if self.current_key != "":
		var indices = KEYS[current_key]
		var amp = (
			Waveforms.sine(t, FREQ_ROWS[indices[0]], 0) +
			Waveforms.sine(t, FREQ_COLS[indices[1]], 0)
		)
		return amp
	else:
		return 0.0

func play_note(note: Note):
	self.current_key = note.instrument_data
	.play_note(note)

func stop_note(note: Note):
	self.current_key = ""
	.stop_note(note)
