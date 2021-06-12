extends VBoxContainer

var InstrumentTrack = preload("./InstrumentTrack.tscn")

onready var tracks = $ScrollContainer/Tracks
onready var scroll_bar = $Scrollbar/HScrollBar

# Takes a Button since it conveniently sends an icon and message
func add_track(instrument: Button):
	var inst = InstrumentTrack.instance()
	inst.set_instrument(instrument.icon, instrument.text)
	tracks.add_child(inst)
#	inst.size_flags_horizontal |= SIZE_FILL
#	inst.rect_min_size.x = 192

func _on_InstrumentsPanel_instrument_chosen(instrument) -> void:
	add_track(instrument)


func _on_HScrollBar_value_changed(value):
	for track in tracks.get_children():
		track.scroll = value

