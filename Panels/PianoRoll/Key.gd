extends Button

class_name Key

signal key_pressed

func _pressed():
	emit_signal("key_pressed", get_parent().get_child_count()-get_index())
