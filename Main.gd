extends Control

onready var player = $AudioStreamPlayer
onready var instrument_tab = $VBoxContainer/HBoxContainer/Instruments

func _init():
	pass

func load_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")
	dir.list_dir_begin(true, true)

	var instrument_name = dir.get_next()
	while instrument_name != "":
		if dir.file_exists("./%s/instrument.gd" % instrument_name):
			var instrument = load("%s/%s/instrument.gd" % [dir.get_current_dir(), instrument_name])
			GoDAW.register_instrument(instrument_name, instrument.new())
			if dir.file_exists("./%s/icon.png" % instrument_name):
				instrument_tab.add_item(instrument_name, load("%s/%s/icon.png" % [dir.get_current_dir(), instrument_name]))
			else:
				instrument_tab.add_item(instrument_name, load("res://util/defaultIcon.png"))
		else:
			push_warning("Instrument %s does not have an instrument.gd file" % instrument_name)

		instrument_name = dir.get_next()

func _ready():
	load_instruments()
	var osc = GoDAW.get_instrument("TripleOsc")
	# Set stream and play
	#player.stream = osc.create_sample()
	#player.play()
