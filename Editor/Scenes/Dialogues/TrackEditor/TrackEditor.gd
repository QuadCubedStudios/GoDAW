extends WindowDialog

onready var settings  = $HSplit/Settings
onready var name_scroll = $HSplit/HBoxContainer/VBoxContainer/NameScroll
onready var scroll = $HSplit/HBoxContainer/Scroll
onready var note_names = $HSplit/HBoxContainer/VBoxContainer/NameScroll/NoteName
onready var notes = $HSplit/HBoxContainer/Scroll/Notes
onready var grid = $HSplit/HBoxContainer/Grid

var scrolling_on_editor = false

func _ready():
	var theme = Theme.new()
	theme.set_stylebox("scroll", "VScrollBar", StyleBoxEmpty.new())
	name_scroll.get_v_scrollbar().theme = theme
	
	name_scroll.get_v_scrollbar().connect("value_changed", self, "name_scroll_changed")
	scroll.get_v_scrollbar().connect("value_changed", self, "scroll_changed")
	scroll.get_h_scrollbar().connect("value_changed", self, "h_scroll")

func _popup(instrument):
	window_title = "Edit %s" % instrument.instrument_name
	var s
	for i in range(80):
		var b = Button.new()
		b.disabled
		b.text = "NOTE"
		note_names.add_child(b)
		s = b.rect_size
	var nmg = Image.new()
	nmg.create(100, 80, false, Image.FORMAT_RGBA8)
	nmg.fill(Color.transparent)
	nmg.lock()
	for i in 40:
		nmg.set_pixel(i, i+i*1, Color.white)
	nmg.unlock()
	var image = ImageTexture.new()
	image.create_from_image(nmg, 1)
	var t = TextureRect.new()
	t.expand = true
	t.rect_min_size = Vector2(100*s.y, 80*s.y)
	t.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT
	t.texture = image
	notes.add_child(t)
	popup_centered()

func name_scroll_changed(_n):
	scroll.scroll_vertical = name_scroll.scroll_vertical
	grid.update()
	
func scroll_changed(_n):
	name_scroll.scroll_vertical = scroll.scroll_vertical
	grid.update()

func h_scroll(_n): grid.update()

func _on_NoteName_resized():
	scroll.rect_size = name_scroll.rect_size
