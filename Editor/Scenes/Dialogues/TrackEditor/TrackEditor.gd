extends WindowDialog

onready var hbox = $HBox

func _popup(instrument_name, settings, editor):
	window_title = "Edit %s" % instrument_name
	popup()
