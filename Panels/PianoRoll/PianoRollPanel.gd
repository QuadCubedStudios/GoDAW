extends Panel

const OCTAVE = "WBWBWBWWBWBW"

var white_key = preload("res://Panels/PianoRoll/White.tscn")
var black_key = preload("res://Panels/PianoRoll/Black.tscn")
var spawn_point = 0
var key_no = 95

onready var hbox = $VBox/HBox
onready var piano_container = $VBox/HBox/PianoContainer
onready var piano = piano_container.get_node("PianoViewport")
onready var white_keys = piano.get_node("white_keys")
onready var black_keys = piano.get_node("black_keys")
onready var grid = piano.get_node("Grid/Grid")
onready var players = $Players

enum KEY {WHITE, BLACK}

func _ready():
	var _n = Global.connect("window_size_changed", self, "fix_window")
	fix_window(OS.window_size)
	for _i in range(8):
		add_octave()

func fix_window(window_size):
	piano.size.y = hbox.rect_size.y-10
	piano_container.rect_size.y = hbox.rect_size.y-10
	piano.size.x = window_size.x - 300
	piano_container.rect_size.y = window_size.x - 300

func add_key(key, prev_key):
	var new_key = white_key.instance() if key == "W" else black_key.instance()
	(white_keys if key == "W" else black_keys).add_child(new_key)
	if black_keys.get_child_count() == 0 && white_keys.get_child_count() == 1:
		spawn_point= 0
	elif prev_key == "B":
		spawn_point += 7
	elif key == "B":
		spawn_point += 17
	elif key == "W":
		spawn_point += 24
	new_key.rect_position.y = spawn_point
	new_key.key_no = key_no+4
	key_no -= 1

func add_octave():
	for i in range(len(OCTAVE)):
		add_key(OCTAVE[i], OCTAVE[i-1])
