extends Resource

class_name SongScript

var sequence: SongSequence

func _init():
	self.sequence = SongSequence.new()

func track(instrument: String, notes: Array):
	var track = Track.new()
	track.instrument = instrument
	# Convenient for nested patterns
	track.notes = pattern(notes)

	self.sequence.add_track(track)

func pattern(notes: Array, repeat: int = 1, start_delta: float = 0.0) -> Array:
	if notes.empty(): return []
	var expanded = []
	for _i in repeat:
		for el in notes:
			if el is Note:
				expanded.append(el)
			elif el is Array:
				expanded.append_array(pattern(el))

	# TODO: Move note copy code elsewhere
	var new_first = Note.new()
	new_first.note_start_delta = (expanded[0] as Note).note_start_delta + start_delta
	new_first.duration = (expanded[0] as Note).duration
	new_first.instrument_data = (expanded[0] as Note).instrument_data

	expanded[0] = new_first
	return expanded

func note(note_start_delta: float, duration: float, data) -> Note:
	var note = Note.new()
	note.note_start_delta = note_start_delta
	note.duration = duration
	note.instrument_data = data
	return note

# The function where notes go
func song():
	pass

func entry():
	sequence.tracks.clear()
	song()
