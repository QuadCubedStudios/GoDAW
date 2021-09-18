extends LiveSynthesisInstrument

const OCTAVE_FACTOR = pow(2, 1.0/12)

var currently_playing := {}

func _init().("TripleOsc", 22050):
	pass

func waveform(t: float):
	# Example function: Adds amplitudes of multiple waveforms

	# Add amplitudes
	var amp = 0
	for key in currently_playing:
		var freq = to_hertz(currently_playing[key].key)
		for a in [
			Waveforms.sine(t, freq, 0),
			0.5 * Waveforms.sine(t, 2 * freq, 0),
			0.25 * Waveforms.sine(t, 3 * freq, 0),
		]:
			amp += a

	# Return normalized wave
	if currently_playing.size() == 0:
		return 0
	return amp / currently_playing.size()

# TODO: Move this to MIDI later
func to_hertz(key_no):
	return pow(OCTAVE_FACTOR, (key_no - 69)) * 440

func play_note(note: Note):
	self.currently_playing[note.instrument_data.key] = note.instrument_data
	self.currently_playing[note.instrument_data.key].end_t = note.duration
	.play_note(note)

func stop_note(note: Note):
	self.currently_playing.erase(note.instrument_data.key)
	if self.currently_playing.size() == 0:
		.stop_note(note)
