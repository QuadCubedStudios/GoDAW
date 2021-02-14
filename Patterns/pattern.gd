class_name GDW_pattern extends Resource

enum { # events
	NOTE_ON,
	NOTE_OFF,
	PITCH_BEND,
	NONE = -1
}

const bpm = 120.0 # temporary var

var start_position = 0.0 # this pattern starts this many beats from start of timeline
export var length = 4.0
export var data := []
var last_poll_time := 0.0

func new_note(pitch, time):
	return {
		t = time, 	# time: beats (60 * seconds/BPM) since start of pattern
		p = pitch, 	# pitch: MIDI key number
		v = 127,	# velocity: not implemented yet /TODO
		e = NONE	# event: how this note should be played
	}

func add_note(pitch:int, time:float):
	var note = new_note(pitch, time)
	note.e = NOTE_ON
	data.append(note)

func add_noteoff(pitch, time):
	var note = new_note(pitch, time)
	note.e = NOTE_OFF
	data.append(note)


func get_next_events(time) -> Array:
	var events = []
	for e in data:
		if e.t <= time and e.t >= last_poll_time:
			events.append(e)
	last_poll_time = time
	return events

func beats(seconds:float) -> float:
	return 60.0 * seconds * 1/bpm

func sort_by_time(a, b):
	return a.t < b.t

func sort_notes():
	data.sort_custom(self, "sort_by_time")
