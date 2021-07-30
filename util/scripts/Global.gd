extends Node

# Signals
signal play
signal pause
signal stop
signal piano_state_changed
signal segments_changed
signal finished

# Vars
var segments: int = 0 setget set_segments

func set_segments(val: int):
	segments = val
	emit_signal("segments_changed")
	pass
