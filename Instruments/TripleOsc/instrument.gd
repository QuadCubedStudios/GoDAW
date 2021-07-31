extends "res://addons/godaw_toolkit/Classes/Piano.gd"

func _init().("TripleOsc"):
	pass

func waveform(t, freq):
	# Example function: Adds amplitudes of multiple waveforms

	# Sub-waveforms
	var funcs = [
		Waveforms.sine(t, freq),
		0.5 * Waveforms.sine(t, 2 * freq),
		0.25 * Waveforms.sine(t, 3 * freq),
	]

	# Add amplitudes
	var amp = 0
	for f in funcs:
		amp += f

	# Return normalized wave
	return amp / funcs.size()
