extends VBoxContainer

var track_name = preload("./TrackName.tscn")

onready var names = $TracksScroll/HBox/Names
onready var segments = $TracksScroll/HBox/SegmentScroll/VBoxContainer

# styles
var style_1 = preload("res://Theme/Default/SongButton1.tres")
var style_2 = preload("res://Theme/Default/SongButton2.tres")
var style_pressed = preload("res://Theme/Default/SongButtonPressed.tres")

# Takes a Button since it conveniently sends an icon and message
# TODO: Not use button as param
func add_track(instrument: Button):
	var name = track_name.instance()
	var segment_container = HBoxContainer.new()
	name.set_instrument(instrument.icon, instrument.text, segment_container)
	names.add_child(name)
	if Global.segments == 0:
		Global.segments = segments.get_parent().get_size().x/25
	add_segments(segment_container, name.rect_size.y, true)
	segments.add_child(segment_container)

func add_segments(segment_container: HBoxContainer, size, style):
	for i in range(segment_container.get_child_count(),
	Global.segments):
		var segment = Button.new()
		segment.rect_min_size.x = 20
		segment.rect_min_size.y = size
		segment.focus_mode = Control.FOCUS_NONE
		segment.add_stylebox_override("disabled", style_pressed)
		if i % 4 == 0: style = !style
		segment.add_stylebox_override("normal", style_1 if style else style_2)
		segment.add_stylebox_override("hover", style_1 if style else style_2)
		segment.connect("gui_input", self, "segment_input", [segment])
		segment_container.add_child(segment)

func segment_input(event, segment: Button):
	if event is InputEventMouseButton & event.pressed:
		match event.button_index:
			1:
				segment.disabled = true
				if segment.get_index() != Global.segments - 1: return
				Global.segments += segments.get_parent().get_size().x/25
				var style = segment.get_stylebox("normal") == style_1
				add_segments(segment.get_parent(), segment.get_size().x, segment)
			3:
				segment.disabled = false
