extends Node

var root: Viewport
var main: Control
var players : Node
var instruments: VBoxContainer
var instrument: PackedScene
var song_editor: Panel
var piano_roll: Panel
var window_size: Vector2 = Vector2(0, 0)
var selected_instrument: String

signal play
signal pause
signal stop
signal piano_state_changed
signal window_size_changed

func _ready():
	instrument = preload("res://Panels/Instruments/Instrument.tscn")
	root = get_tree().get_root()
	main = get_node("/root/Main")
	players = main.find_node("Player")
	instruments = main.find_node("Instruments")
	song_editor = main.find_node("SongEditor")
	piano_roll = main.find_node("PianoRollPanel")

func _process(_delta):
	if OS.window_size != window_size:
		window_size = OS.window_size
		emit_signal("window_size_changed", window_size)
