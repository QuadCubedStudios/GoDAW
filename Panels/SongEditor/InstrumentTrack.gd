extends Control

export var scroll = 0 setget set_scroll

var instrument_toggle : ToolButton

# styles
var style_1 = preload("res://Theme/Default/SongButton1.tres")
var style_2 = preload("res://Theme/Default/SongButton2.tres")
var style_pressed = preload("res://Theme/Default/SongButtonPressed.tres")

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
		var segment = Button.new()
		segment.rect_min_size.x = 20
		segment.focus_mode = Control.FOCUS_NONE
		segment.add_stylebox_override("disabled", style_pressed)
		segment.add_stylebox_override("normal", style_1 if i % 2 == 0 else style_2)
		segment.add_stylebox_override("hover", style_1 if i % 2 == 0 else style_2)
		segment.connect("gui_input", self, "segment_input", [segment])
		segments.add_child(segment)

func segment_input(event, segment: Button):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				segment.disabled = true
			if event.doubleclick :
				$Panel.visible = !$Panel.visible
			if event.button_index == 3:
				segment.disabled = false

func _on_InstrumentToggle_gui_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 2 && event.pressed:
			delete_confirm.dialog_text = (
				"Are you sure you want to delete track " + instrument_toggle.text)
			delete_confirm.popup_centered()

func _on_DeleteConfirm_confirmed():
	queue_free()
