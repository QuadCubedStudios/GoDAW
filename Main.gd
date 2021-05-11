extends Control

onready var player = $AudioStreamPlayer
#onready var instrument_tab = $VBoxContainer/EditorView/Instruments

export var pattern:Resource = preload("res://Patterns/pattern1.tres")

func _init():
	pass

var bpm = 140

var time := 0.0 # timeline position, not system time

func load_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")
	dir.list_dir_begin(true, true)

	var instrument_name = dir.get_next()
	while instrument_name != "":
		if dir.file_exists("./%s/instrument.gd" % instrument_name):
			var instrument = load("%s/%s/instrument.gd" % [dir.get_current_dir(), instrument_name])
			GoDAW.register_instrument(instrument_name, instrument.new())
#			instrument_tab.add_item(instrument_name, load("%s/%s/icon.png" % [dir.get_current_dir(), instrument_name]))
#			if dir.file_exists("./%s/icon.png" % instrument_name):
#				instrument_tab.add_item(instrument_name, load("%s/%s/icon.png" % [dir.get_current_dir(), instrument_name]))
#			else:
#				instrument_tab.add_item(instrument_name, load("res://util/defaultIcon.png"))

		else:
			push_warning("Instrument %s does not have an instrument.gd file" % instrument_name)

		instrument_name = dir.get_next()

func _ready():
	load_instruments()
	var osc = GoDAW.get_instrument("Square")
	var wave = Wave.new(osc.create_sample())
	wave.position += Vector2(10, 200)
	#add_child(wave)
	# Set stream and play
	player.stream = osc.create_sample()
	player.pitch_scale = 1.0
#	player.play()

func _process(delta):
	time += delta * bpm/60.0
	var events:Array = pattern.get_next_events(time)
	for e in events:
		play_note(e) # TODO: notes don't play with accurate timing

	if time > pattern.length: #simple loop
		time = 0
		pattern.last_poll_time = 0

func play_note(note):
	print(note)
	var transpose = -12
	var pitch = pow(2.0, (transpose + note.p - 64)/12.0)
	player.pitch_scale = pitch
	match note.e:
		GDW_pattern.NOTE_ON:
			player.play()
		GDW_pattern.NOTE_OFF:
			player.stop()
