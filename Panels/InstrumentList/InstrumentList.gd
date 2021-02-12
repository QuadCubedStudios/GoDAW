extends Panel

onready var instrument_tab = $VBoxContainer/List
onready var default_icon = preload("res://Theme/Default/default_icon.png")

func _ready():
	load_instruments()

func add_instrument(name, iconPath, script):
	if GoDAW.instruments.has(name):
		push_warning("Instrument already exists")
		return
	GoDAW.register_instrument(name, load(script).new())
	var file_checker = File.new()
	var exists = file_checker.file_exists(iconPath)
	if exists:
		instrument_tab.add_item(name, load(iconPath))
	else:
		instrument_tab.add_item(name, default_icon)


func load_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")
	dir.list_dir_begin(true, true)

	var instrument_name = dir.get_next()
	while instrument_name != "":
		
		if dir.file_exists("./%s/instrument.gd" % instrument_name):
			var iconPath = "%s/%s/icon.png" % [dir.get_current_dir(), instrument_name]
			var scriptPath = "%s/%s/instrument.gd" % [dir.get_current_dir(), instrument_name]
			add_instrument(instrument_name, iconPath, scriptPath)
				
		else:
			push_warning("Instrument %s does not have an instrument.gd file" % instrument_name)

		instrument_name = dir.get_next()
