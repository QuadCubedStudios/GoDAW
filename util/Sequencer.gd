class_name Sequencer extends Node

# Data
var data: SongSequence
var playing: bool
var paused: bool
var player: AnimationPlayer

# Signals
signal finished


# Functions
func play():
	playing = true
	var song = Animation.new()
	song.set_step(0.001)
	for track in data.tracks:
		track = track as Track
		var track_index = song.add_track(Animation.TYPE_METHOD)
		var inst = GoDAW.get_instrument(track.instrument)
		add_child(inst)
		song.track_set_path(track_index, track.instrument)
		for note in track.notes:
			note = note as Note
			song.track_insert_key(track_index, note.note_start,
				{
					"method": "play_note",
					"args": [note]
				})
			var dur = note.note_start + note.duration
			if dur > song.length: song.length = dur
	player = AnimationPlayer.new()
	add_child(player)
	player.add_animation("song", song)
	player.root_node = self.get_path()
	player.play("song")

func stop():
	playing = false
	# Code to stop

func seek():
	# Change with code to seek
	pass
