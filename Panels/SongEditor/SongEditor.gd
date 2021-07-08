extends VBoxContainer

var track_name = preload("./TrackName.tscn")
var song_segment = preload("./SongSegment.tscn")

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
	name.set_instrument(instrument.icon, instrument.text)
	names.add_child(name)
	var segment_container = HBoxContainer.new()
	if Global.segments == 0:
		Global.segments = segments.get_parent().get_size().x/30
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
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == 1:
				segment.disabled = true
				if segment.get_index() == Global.segments - 1:
					print(Global.segments)
					Global.segments += segments.get_parent().get_size().x/30
					print(Global.segments)
					add_segments(segment.get_parent(), segment.get_size().x, false)
#			if event.doubleclick :
#				$Panel.visible = !$Panel.visible
			if event.button_index == 3:
				segment.disabled = false
