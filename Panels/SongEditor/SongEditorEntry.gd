extends HBoxContainer

var type = true
var type1: StyleBoxFlat = preload("res://Theme/Default/SongButton1.tres")
var type2: StyleBoxFlat = preload("res://Theme/Default/SongButton2.tres")
var segment: PackedScene = preload("res://Panels/SongEditor/SongSegment.tscn")
const zoom_min = 0.5
const zoom_max = 2
onready var instrument = $Instrument
onready var viewport_container = $ViewportContainer
onready var viewport = viewport_container.get_node("Viewport")
onready var camera = viewport.get_node("Camera")
onready var segment_container = viewport.get_node("HBoxContainer")
onready var disabled = Global.piano_roll.viewport.get_node("Disabled/ColorRect")

func _ready():
	var idx = 0
	while 80 * idx <= viewport.size.x:
		idx+=1
		for _j in range(4):
			spawn_segment()
	Global.connect("window_size_changed", self, "window_size_changed")

func window_size_changed(window_size):
		var size = window_size.x - 530
		viewport.size.x = size
		viewport_container.rect_size.x = size

func _on_HBoxContainer_gui_input(event):
	if event.is_action("scroll_up"):
		set_zoom(-0.01)
	elif event.is_action("scroll_down"):
		set_zoom(0.01)

func segment_input(event, song_segment):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.doubleclick:
			Global.selected_instrument = self
			disabled.hide()
		elif event.button_index == 2:
			song_segment.set_disabled(false)

func set_zoom(val: float):
	var new_zoom = camera.zoom.x + val
	if new_zoom < zoom_min or new_zoom > zoom_max:
		new_zoom = camera.zoom.x
	camera.zoom.x = new_zoom

func spawn_segment():
	if segment_container.get_child_count()%4 == 0: type = !type
	var new_segment = segment.instance()
	new_segment.add_stylebox_override("normal", type1 if type else type2)
	new_segment.add_stylebox_override("hover", type1 if type else type2)
	segment_container.add_child(new_segment)
	new_segment.connect("gui_input", self, "segment_input", [new_segment])
	new_segment.connect("button_down", new_segment, "set_disabled", [true])

func init(text: String, icon: Resource):
	$Instrument.init(icon, text)

func fix_segments(zoom, scroll):
	pass
