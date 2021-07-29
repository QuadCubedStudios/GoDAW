extends Instrument

func _init().("TripleOsc"):
	pass

func waveform(t, freq):
	# Example function: Adds amplitudes of multiple waveforms

	# Sub-waveforms
	var funcs = [
		OSC.osc(t, 200.00, OSC.SIN),
		OSC.osc(t, 400.00, OSC.SIN),
		OSC.osc(t, 600.00, OSC.SIN),
	]

	# Add amplitudes
	var amp = 0
	for f in funcs:
		amp += f

	# Return normalized wave
	return amp / funcs.size()
