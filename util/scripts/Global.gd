extends Node

#var root: Viewport
#var main: Control
#var players : Node
#var instruments: VBoxContainer
#var instrument: PackedScene
#var song_editor: Control
#var piano_roll: Panel
#var selected_instrument: String

signal play
signal pause
signal stop
signal piano_state_changed
signal window_size_changed

func _ready():
	pass
#	root = get_tree().get_root()
#	main = get_node("/root/Main")
#	players = main.find_node("Player")
#	instruments = main.find_node("Instruments")
#	song_editor = main.find_node("SongEditor")
#	piano_roll = main.find_node("PianoRollPanel")
