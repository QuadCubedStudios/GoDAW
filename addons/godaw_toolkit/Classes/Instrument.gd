extends Node

class_name Instrument

var bus_idx: int
var instrument_name

func _init(instrument_name: String):
	self.instrument_name = instrument_name
	
	# Each instrument need to output audio to this bus
	self.bus_idx = AudioServer.bus_count
	AudioServer.add_bus(self.bus_idx)

func play_note(note):
	pass

func stop_note(note):
	pass
