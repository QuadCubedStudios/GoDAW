extends ToolButton

onready var delete_confirm: ConfirmationDialog = $DeleteConfirm

var segments: HBoxContainer

func set_instrument(icon: Texture, instrument_name: String, segments: HBoxContainer) -> void:
	self.icon = icon
	self.text = instrument_name
	if instrument_name.length() > 20:
		self.text = instrument_name.substr(0, 17) + "..."
	self.segments = segments

#func _on_InstrumentToggle_gui_input(event):
#	if event is InputEventMouseButton:
#		if event.button_index == 3 && event.pressed:
#			delete_confirm.dialog_text = (
#				"Are you sure you want to delete track " + self.text)
#			delete_confirm.popup_centered()

func _on_DeleteConfirm_confirmed():
	segments.queue_free()
	queue_free()
