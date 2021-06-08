extends Control


func set_instrument(icon: Texture, instrument_name: String) -> void:
	var instrument_toggle = $HBoxContainer/InstrumentToggle
	instrument_toggle.icon = icon
	instrument_toggle.text = (instrument_name if instrument_name.length() <= 20
								else instrument_name.substr(0, 17) + "...")
