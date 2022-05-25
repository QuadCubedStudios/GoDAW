extends VBoxContainer

# Signals
signal playback_finished()
signal track_pressed (name)

var track_name = preload("./TrackName.tscn")

onready var names = $TracksScroll/HBox/Names
onready var sequencer = $Sequencer

# styles
# techno: Make this support different themes
var style_1 = preload("res://Themes/Default/SongButton1.tres")
var style_2 = preload("res://Themes/Default/SongButton2.tres")
var style_pressed = preload("res://Themes/Default/SongButtonPressed.tres")

# Takes a Button since it conveniently sends an icon and message
# TODO: Not use button as param
func add_track(instrument: Button):
	var name = track_name.instance()
	name.set_instrument(instrument.icon, instrument.text)
	names.add_child(name)
	name.connect("pressed", self, "emit_signal", ["track_pressed", instrument.text])
	
	# TODO: Hacky code
	var inst := GoDAW.get_instrument(instrument.text)
	$Sequencer.INSTRUMENTS[instrument.text] = inst

func _on_play():
	sequencer.play()

func _on_pause():
	sequencer.pause()

func _on_stop():
	sequencer.stop()

func _on_Sequencer_playback_finished():
	emit_signal("playback_finished")


func _on_TrackEditor_sequence_song(sequence):
	sequencer.sequence(sequence)
