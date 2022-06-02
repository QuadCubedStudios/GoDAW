extends Node

class_name Instrument

var bus_idx: int
var instrument_name: String


func _init(instrument_name: String):
	self.instrument_name = instrument_name
	
	# Each instrument need to output audio to this bus
	self.bus_idx = AudioServer.bus_count
	AudioServer.add_bus(self.bus_idx)

func get_new_player() -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	
	# Defaults go here
	player.bus = AudioServer.get_bus_name(self.bus_idx)
	add_child(player)
	return player

func play_note(note: Note):
	pass

func stop_note(note: Note):
	pass
