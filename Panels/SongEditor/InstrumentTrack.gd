extends Control


func set_instrument(icon: Texture, instrument_name: String) -> void:
	var instrument_toggle = $HBoxContainer/InstrumentToggle
	instrument_toggle.icon = icon
	instrument_toggle.text = (instrument_name if instrument_name.length() <= 20
								else instrument_name.substr(0, 17) + "...")


func _on_Segments_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			$Panel.visible = !$Panel.visible
