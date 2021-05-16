extends Panel

const SEMITONE = "BWBWWBWBWWBW"

var white_key = preload("res://Panels/PianoRoll/White.tscn")
var black_key = preload("res://Panels/PianoRoll/Black.tscn")
var spawn_point = 0
var key_no = 119

onready var hbox = $VBox/HBox
onready var piano_container = $VBox/HBox/PianoContainer
onready var piano = piano_container.get_node("PianoViewport")
onready var white_keys = piano.get_node("white_keys")
onready var black_keys = piano.get_node("black_keys")
onready var notes_container = $VBox/HBox/NoteContainer
onready var notes = notes_container.get_node("NotesViewport")

enum KEY {WHITE, BLACK}

func _ready():
	var _n = Global.connect("window_size_changed", self, "fix_window")
	fix_window(null)
	for _i in range(10):
		add_semitone()

func fix_window(window_size):
	piano.size.y = hbox.rect_size.y-10
	piano_container.rect_size.y = hbox.rect_size.y-10
	notes.size.y = hbox.rect_size.y-10
	notes_container.rect_size.y = hbox.rect_size.y-10
#	notes.size.x = window_size.x-20
#	notes_container.rect_size.x = window_size.x-20

func add_key(key, prev_key):
	var new_key = white_key.instance() if key == "W" else black_key.instance()
	(white_keys if key == "W" else black_keys).add_child(new_key)
	if black_keys.get_child_count() == 1:
		if white_keys.get_child_count() == 1:
			spawn_point += 15
		else: return
	elif prev_key == "B":
		spawn_point += 5
	elif key == "W":
		spawn_point += 20
	else:
		spawn_point += 15
	new_key.rect_position.y = spawn_point
	new_key.key_no = key_no
	key_no -= 1

func add_semitone():
	for i in range(len(SEMITONE)):
		add_key(SEMITONE[i], SEMITONE[i-1])
