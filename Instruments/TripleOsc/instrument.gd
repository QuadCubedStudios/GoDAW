extends Instrument

func _init().("TripleOsc"):
	pass

func waveform(t):
	# Example function: Adds amplitudes of multiple waveforms

	# Sub-waveforms
	var funcs = [
		Waveforms.sine(t, 200.00),
		Waveforms.sine(t, 400.00),
		Waveforms.sine(t, 600.00),
	]

	# Add amplitudes
	var amp = 0
	for f in funcs:
		amp += f

	# Return normalized wave
	return amp / funcs.size()
