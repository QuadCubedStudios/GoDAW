extends "res://addons/godaw_toolkit/Classes/Piano.gd"

func _init().("Square"):
	pass

func waveform(t, freq):
	# Example function: Adds amplitudes of multiple waveforms

	# Sub-waveforms
	var funcs = [
		OSC.osc(t, freq, OSC.SQR),
	]

	# Add amplitudes
	var amp = 0
	for f in funcs:
		amp += f

	# Return normalized wave
	return amp / funcs.size()
