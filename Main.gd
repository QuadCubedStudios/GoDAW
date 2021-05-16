extends Control

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
			if dir.file_exists("./%s/Icon.png" % instrument_name):
				add_instrument(instrument_name, load("%s/%s/Icon.png" % [dir.get_current_dir(), instrument_name]))
			else:
				add_instrument(instrument_name, load("res://Theme/Default/default_icon.png"))

		else:
			push_warning("Instrument %s does not have an instrument.gd file" % instrument_name)

		instrument_name = dir.get_next()

func _ready():
	load_instruments()
	Global.song_editor.rect_position.y = 80
	Global.song_editor.rect_size.y = ((OS.window_size.y-80)/2)-10
	Global.piano_roll.rect_position.y = ((OS.window_size.y-80)/2)+80
	Global.piano_roll.rect_size.y = ((OS.window_size.y-80)/2)-10

#	player.play()

#func _process(delta):
	time *= bpm/60.0
	var events:Array = pattern.get_next_events(time)
	print(events)
#	for e in events:
#		play_note(e) # TODO: notes don't play with accurate timing
#
#	if time > pattern.length: #simple loop
#		time = 0
#		pattern.last_poll_time = 0
#


func add_instrument(instrument_name: String, icon: Resource):
	var new_instrument = Global.instrument.instance()
	var center = CenterContainer.new()
	center.add_child(new_instrument)
	new_instrument.init(icon, instrument_name)
	Global.instruments.add_child(center)
