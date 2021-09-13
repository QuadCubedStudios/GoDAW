extends Node

var instruments = {}

func register_instrument(name: String, instrument: PackedScene):
	self.instruments[name] = instrument

func get_instrument(name: String) -> Instrument:
	return self.instruments[name].instance()
