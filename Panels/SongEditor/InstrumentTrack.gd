extends Control

export var scroll = 0 setget set_scroll

var instrument_toggle : ToolButton

onready var segments = $HBoxContainer/ScrollView/Segments
onready var delete_confirm = $DeleteConfirm

func set_scroll(val):
	if val >= 0:
		segments.set_position(Vector2(-val*10, 0))
	scroll = val

func set_instrument(icon: Texture, instrument_name: String) -> void:
	instrument_toggle = $HBoxContainer/InstrumentToggle
	instrument_toggle.icon = icon
	instrument_toggle.text = (instrument_name if instrument_name.length() <= 20
								else instrument_name.substr(0, 17) + "...")

func _ready():
	for i in range(100):
		segments.add_child(Button.new())

func _on_Segments_gui_input(event):
	if event is InputEventMouseButton:
		if event.doubleclick:
			$Panel.visible = !$Panel.visible

func _on_InstrumentToggle_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.pressed:
			delete_confirm.dialog_text = (
				"Are you sure you want to delete track " + instrument_toggle.text)
			delete_confirm.popup_centered()

func _on_DeleteConfirm_confirmed():
	queue_free()
