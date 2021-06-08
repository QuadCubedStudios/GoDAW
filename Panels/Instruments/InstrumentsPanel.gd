extends Control

signal instrument_chosen(instrument)

func _ready() -> void:
	var dir = Directory.new()
	dir.open("res://Instruments")

	for instrument in GoDAW.instruments:
		var btn = ToolButton.new()

		var icon = null
		if dir.file_exists("./%s/Icon.png" % instrument):
			icon = load("%s/%s/Icon.png" % [dir.get_current_dir(), instrument])
		else:
			icon = load("res://Theme/Default/default_icon.png")

		btn.icon = icon
		btn.text = instrument
		btn.flat = false
		btn.focus_mode = Control.FOCUS_NONE
		btn.connect("pressed", self, "_on_Instrument_pressed", [btn])
		$Instruments/VBoxContainer.add_child(btn)

func _on_Instrument_pressed(button) -> void:
	emit_signal("instrument_chosen", button)
