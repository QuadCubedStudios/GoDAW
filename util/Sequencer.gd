class_name Sequencer extends Node

# Data
var data: SongSequence
var playing: bool
var paused: bool
var player: AnimationPlayer

# Signals
signal finished


# Functions
func sequence(sequence: SongSequence):
	for i in get_children(): i.queue_free()
	data = sequence
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
	Global.connect("pause", self, "pause")
	Global.connect("stop", self, "stop")
	Global.connect("play", self, "play")

func play():
	playing = true
	if paused: 
		paused = false
		player.play()
		return
	player.play("song")

func stop():
	playing = false
	player.stop()

func pause():
	paused = true
	player.stop(false)

func seek(sec: float):
	player.seek(sec, true)
	pass
