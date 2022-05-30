extends ToolButton

onready var delete_confirm: ConfirmationDialog = $DeleteConfirm

func set_instrument(icon: Texture, instrument_name: String) -> void:
	self.icon = icon
	self.text = instrument_name
	if instrument_name.length() > 20:
		self.text = instrument_name.substr(0, 17) + "..."

func _on_DeleteConfirm_confirmed():
	queue_free()
