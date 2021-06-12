extends Node

# Signals
signal play
signal pause
signal stop
signal piano_state_changed
signal window_size_changed

# Vars
var scroll: int = 0
var last_segment: int = 0

# Nodes
var root
var song_editor: HBoxContainer

func _ready():
	root = get_tree().get_root()
	song_editor = root.find_node("SongEditor")
