extends Control

signal instrument_chosen(instrument)

func reload_instruments():
	var dir = Directory.new()
	dir.open("res://Instruments")

	for instrument in GoDAW.instruments:
		var btn = ToolButton.new()

		var icon = null
		if dir.file_exists("./%s/Icon.png" % instrument):
			icon = load("%s/%s/Icon.png" % [dir.get_current_dir(), instrument])
		else:
			icon = load("res://Themes/Default/Images/default_icon.png")

		btn.icon = icon
		btn.text = instrument if instrument.length() <= 20 else instrument.substr(0, 17) + "..."
		btn.flat = false
		btn.focus_mode = Control.FOCUS_NONE
		btn.connect("pressed", self, "_on_Instrument_pressed", [btn])
		$Instruments/VBoxContainer.add_child(btn)

func _on_Instrument_pressed(button) -> void:
	emit_signal("instrument_chosen", button)
