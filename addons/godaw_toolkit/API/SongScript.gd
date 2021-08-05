extends Node

class_name SongScript

var sequence: SongSequence

func _init():
	self.sequence = SongSequence.new()

func track(instrument: String, notes: Array):
	var track = Track.new()
	track.instrument = instrument
	# Convenient for nested patterns
	track.notes = pattern(1, notes)

	self.sequence.add_track(track)

func pattern(repeat: int, notes: Array) -> Array:
	var expanded = []
	for _i in repeat:
		for el in notes:
			if el is Note:
				expanded.append(el)
			elif el is Array:
				expanded.append_array(pattern(1, el))

	return expanded

func note(note_start_delta: float, duration: float, data) -> Note:
	var note = Note.new()
	note.note_start_delta = note_start_delta
	note.duration = duration
	note.instrument_data = data
	return note

func entry():
	pass
