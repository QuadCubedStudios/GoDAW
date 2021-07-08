extends ToolButton

onready var delete_confirm: ConfirmationDialog = $DeleteConfirm

func set_instrument(icon: Texture, instrument_name: String) -> void:
	self.icon = icon
	self.text = (instrument_name if instrument_name.length() <= 20
								else instrument_name.substr(0, 17) + "...")

func _on_InstrumentToggle_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 3 && event.pressed:
			delete_confirm.dialog_text = (
				"Are you sure you want to delete track " + self.text)
			delete_confirm.popup_centered()

func _on_DeleteConfirm_confirmed():
	queue_free()
