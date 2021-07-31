extends Node

signal playback_finished()

onready var instruments = $Instruments
onready var player = $AnimationPlayer

# Data
var data: SongSequence
var playing: bool
var paused: bool

# Functions
func sequence(sequence: SongSequence):
	for i in instruments.get_children():
		i.queue_free()

	data = sequence
	var song = Animation.new()
	song.set_step(0.001)

	for track in data.tracks:
		track = track as Track
		var track_index = song.add_track(Animation.TYPE_METHOD)
		var inst = GoDAW.get_instrument(track.instrument)
		instruments.add_child(inst)

		song.track_set_path(track_index, "Instruments/" + inst.name)
		for note in track.notes:
			note = note as Note
			song.track_insert_key(track_index, note.note_start,
				{
					"method": "play_note",
					"args": [note]
				})
			var dur = note.note_start + note.duration
			if dur > song.length: song.length = dur

	player.add_animation("song", song)

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

func finished(_anim):
	emit_signal("playback_finished")
	pass
