extends Node

signal loading_progress_max_value_changed(max_value)
signal loading_progress_value_changed()
signal loading_instrument_changed(instrument_named)

var instruments = {}

func register_instrument(name: String, instrument: PackedScene):
	self.instruments[name] = instrument

func get_instrument(name: String) -> Instrument:
	return self.instruments[name].instance()

func load_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")
	dir.list_dir_begin(true, true)

	var instruments = []

	var instrument_name = dir.get_next()
	while instrument_name != "":
		if dir.file_exists("./%s/Instrument.tscn" % instrument_name):
			instruments.append(instrument_name)
		else:
			push_warning("Instrument %s does not have an Instrument.tscn file" % instrument_name)

		instrument_name = dir.get_next()

	emit_signal("loading_progress_max_value_changed", instruments.size())

	for name in instruments:
		emit_signal("loading_instrument_changed", name)

		yield(get_tree(), "idle_frame")
		var instrument: PackedScene = load("%s/%s/Instrument.tscn" % [dir.get_current_dir(), name])
		GoDAW.register_instrument(name, instrument)
		emit_signal("loading_progress_value_changed")
