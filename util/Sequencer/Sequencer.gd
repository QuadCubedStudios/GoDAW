extends Node

signal playback_finished()
signal on_note(progress)

export var INSTRUMENTS = {}
onready var player = $AnimationPlayer

# Data
var data: SongSequence
var playing: bool
var paused: bool

# Functions
func sequence(sequence: SongSequence):
	data = sequence
	var song = Animation.new()
	song.set_step(0.001)

	for track in data.tracks:
		track = track as Track
		var track_index = song.add_track(Animation.TYPE_METHOD)

		song.track_set_path(track_index, ".")
		var current_time = 0.0
		for note in track.notes:
			note = note as Note

			current_time += note.note_start_delta
			song.track_insert_key(track_index, current_time, {
				"method": "play_note",
				"args": [track.instrument, note]
			})

			song.track_insert_key(track_index, current_time + note.duration, {
				"method": "stop_note",
				"args": [track.instrument, note]
			})

		song.length = current_time + track.notes[-1].duration

	player.add_animation("song", song)

func play_note(instrument_name: String, note):
	emit_signal("on_note", (player.current_animation_position/player.current_animation_length)*100)
	(INSTRUMENTS[instrument_name] as Instrument).play_note(note)

func stop_note(instrument_name: String, note):
	emit_signal("on_note", (player.current_animation_position/player.current_animation_length)*100)
	(INSTRUMENTS[instrument_name] as Instrument).stop_note(note)

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
