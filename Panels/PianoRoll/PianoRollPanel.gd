extends Panel

const SEMITONE = "WBWWBWBWWBWB"

var white_key = preload("res://Panels/PianoRoll/White.tscn")
var black_key = preload("res://Panels/PianoRoll/Black.tscn")
var spawn_point = 0
var key_no = 1

onready var hbox = $VBox/HBox
onready var viewport_container = $VBox/HBox/ViewportContainer
onready var viewport = viewport_container.get_node("Viewport")
onready var white_keys = viewport.get_node("white_keys")
onready var black_keys = viewport.get_node("black_keys")
onready var camera = viewport.get_node("Camera")

enum KEY {WHITE, BLACK}

func _ready():
	var _n = Global.connect("window_size_changed", self, "fix_window")
	fix_window(null)
	for _i in range(10):
		add_semitone()

func fix_window(_window_size):
	viewport.size.y = hbox.rect_size.y-10
	viewport_container.rect_size.y = hbox.rect_size.y-10

func add_key(key, prev_key):
	var new_key = white_key.instance() if key == "W" else black_key.instance()
	(white_keys if key == "W" else black_keys).add_child(new_key)
	if white_keys.get_child_count() == 1: return
	if prev_key == "B":
		spawn_point += 5
	elif key == "W":
		spawn_point += 20
	else:
		spawn_point += 15
	new_key.rect_position.y = spawn_point
	new_key.key_no = key_no
	key_no += 1

func add_semitone():
	for i in range(len(SEMITONE)):
		add_key(SEMITONE[i], SEMITONE[i-1])
