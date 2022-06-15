extends WindowDialog

onready var settings  = $HBox/Settings
onready var name_scroll = $HSplit/HBoxContainer/NameScroll
onready var scroll = $HSplit/HBoxContainer/Scroll
onready var note_names = $HSplit/HBoxContainer/NameScroll/NoteName
onready var grid = $HSplit/HBoxContainer/Scroll/Notes

var scrolling_on_editor = false

func _ready():
	var theme = Theme.new()
	theme.set_stylebox("scroll", "VScrollBar", StyleBoxEmpty.new())
	name_scroll.get_v_scrollbar().theme = theme
	set_process(false)

func _popup(instrument):
	window_title = "Edit %s" % instrument.instrument_name
	for i in range(50):
		var b = Button.new()
		b.disabled
		note_names.add_child(b)
	for i in range(80):
		var b = Button.new()
		b.disabled
		grid.add_child(b)
	popup()

func _process(delta):
	if scrolling_on_editor:
		name_scroll.scroll_vertical = scroll.scroll_vertical
	pass

func _on_Scroll_scroll_ended():
	scrolling_on_editor = true
	set_process(false)

func _on_Scroll_scroll_started():
	scrolling_on_editor = true
	set_process(true)

func _on_NameScroll_scroll_ended():
	scrolling_on_editor = false
	set_process(false)

func _on_NameScroll_scroll_started():
	scrolling_on_editor = false
	set_process(true)

func _on_NoteName_resized():
	print("IIIII")
	grid.rect_size = note_names.rect_size
