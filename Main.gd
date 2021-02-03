extends Control

onready var player = $AudioStreamPlayer
onready var instrument_tab = $VBoxContainer/EditorView/Instruments

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
			instrument_tab.add_item(instrument_name, load("%s/%s/icon.png" % [dir.get_current_dir(), instrument_name]))
		else:
			push_warning("Instrument %s does not have an instrument.gd file" % instrument_name)

		instrument_name = dir.get_next()

func _ready():
	load_instruments()
	var osc = GoDAW.get_instrument("TripleOsc")
	var wave = Wave.new(osc.create_sample())
	wave.position += Vector2(10, 200)
	wave.x_index=5
	add_child(wave)
	# Set stream and play
	#player.stream = osc.create_sample()
	#player.play()
