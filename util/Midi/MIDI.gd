class_name MIDI extends Resource

# MIDI classes
class MidiEvent:
	enum { NoteOff, NoteOn, Other }
	var type; var key; var wall_tick; var delta_tick
	func _init(t, k = 0, w = 0, d = 0):
		self.type = t
		self.key = k
		self.wall_tick = w
		self.delta_tick = d

class MidiNote:
	func _init(key = 0, velocity = 0, start_time = 0, duration = 0):
		self.key = key
		self.velocity = velocity
		self.start_time = start_time
		self.duration = duration
	pass

class MidiTrack:
	var name; var instrument; var events; var notes
	var max_note; var min_note
	func _init(na = "", i = "", e = [],
		no = [], mi=64, ma = 64):
			name = na
			instrument = i
			events = e
			notes = no
			max_note = ma
			min_note = mi

# Enums

# MIDI Event Names
enum EventName  {
	VoiceNoteOff = 0x80,
	VoiceNoteOn = 0x90,
	VoiceAftertouch = 0xA0,
	VoiceControlChange = 0xB0,
	VoiceProgramChange = 0xC0,
	VoiceChannelPressure = 0xD0,
	VoicePitchBend = 0xE0,
	SystemExclusive = 0xF0,
	}
#Meta Event Names
enum MetaEventName  {
	MetaSequence = 0x00,
	MetaText = 0x01,
	MetaCopyright = 0x02,
	MetaTrackName = 0x03,
	MetaInstrumentName = 0x04,
	MetaLyrics = 0x05,
	MetaMarker = 0x06,
	MetaCuePoint = 0x07,
	MetaChannelPrefix = 0x20,
	MetaEndOfTrack = 0x2F,
	MetaSetTempo = 0x51,
	MetaSMPTEOffset = 0x54,
	MetaTimesSignature = 0x58,
	MetaKeySignature = 0x59,
	MetaSequencerSpecifi = 0x7F,
	}


# Vars
var tracks = []
export var tempo = 0
export var bpm = 0


# function to parse files to midi
func parse_file(filename: String = "") -> bool:
	# Open file, if any errors return false
	var input_file = File.new()
	var err = input_file.open(filename, File.READ)
	if err:
		return false

	# Parse MIDI File

	# Read the header of MIDI File
	var _file_id = swap32(input_file.get_32())
	var _header_length = swap32(input_file.get_32())
	var _format = swap16(input_file.get_16())
	var track_chunks = swap16(input_file.get_16())
	var _division = swap16(input_file.get_16())

	# Read data from the MIDI File
	for chunk in range(track_chunks):
		#print("++New Track++")
		# Read Track Header
		var _track_id = swap32(input_file.get_32())
		var _track_lenght = swap32(input_file.get_32())

		var end_of_track = false
		var previous_status = 0

		tracks.append(MidiTrack.new())

		while !input_file.eof_reached() && !end_of_track:
			# All MIDI Events contain a timecode and a status byte
			var status_time_delta = 0
			var status = 0

			# Read Timecode
			status_time_delta = read_value(input_file)
			status = input_file.get_8()

			if status < 0x80:
				status = previous_status
				input_file.seek(input_file.get_position()-1)

			# Match on the event.
			match (status & 0xF0):
				EventName.VoiceNoteOff:
					previous_status = status
					var _channel = status & 0x0F
					var note_id = input_file.get_8()
					var note_velocity = input_file.get_8()
					tracks[chunk].events.append(MidiEvent.new(MidiEvent.NoteOff, note_id,
						note_velocity, status_time_delta))

				EventName.VoiceNoteOn:
					previous_status = status
					var _channel = status & 0x0F
					var note_id = input_file.get_8()
					var note_velocity = input_file.get_8()
					if note_velocity == 0:
						tracks[chunk].events.append(MidiEvent.new(MidiEvent.NoteOff, note_id,
							note_velocity, status_time_delta))
					else:
						tracks[chunk].events.append(MidiEvent.new(MidiEvent.NoteOn, note_id,
							note_velocity, status_time_delta))
				EventName.VoiceAftertouch:
					previous_status = status
					var _channel = status & 0x0F
					var _note_id = input_file.get_8()
					var _note_velocity = input_file.get_8()
					tracks[chunk].events.append(MidiEvent.new(MidiEvent.Other))
				EventName.VoiceControlChange:
					previous_status = status
					var _channel = status & 0x0F
					var _note_id = input_file.get_8()
					var _note_velocity = input_file.get_8()
					tracks[chunk].events.append(MidiEvent.new(MidiEvent.Other))
				EventName.VoiceChannelPressure:
					previous_status = status
					var _channel = status & 0x0F
					var _channel_pressure = input_file.get_8()
					tracks[chunk].events.append(MidiEvent.new(MidiEvent.Other))
				EventName.VoicePitchBend:
					previous_status = status
					var _channel = status & 0x0F
					var _LS7B = input_file.get_8()
					var _MS7B = input_file.get_8()
					tracks[chunk].events.append(MidiEvent.new(MidiEvent.Other))
				EventName.SystemExclusive:
					if status == 0xF0:
						#System Exclusive Message Begin
						print("System Exclusive Begin: " + read_string(input_file,
							read_value(input_file)))
					if status == 0xF7:
						print("System Exclusive End: " + read_string(input_file,
							read_value(input_file)))
					if status == 0xFF:
						# Meta Message
						var type = input_file.get_8()
						var length = read_value(input_file)
						match type:
							MetaEventName.MetaSequence:
								print("Sequence Number: ", input_file.get_8(), input_file.get_8())
							MetaEventName.MetaText:
								print("Text: ", read_string(input_file, length))
							MetaEventName.MetaCopyright:
								print("Copyright: ", read_string(input_file, length))
							MetaEventName.MetaTrackName:
								tracks[chunk].name = read_string(input_file, length)
								print("Track Name: ", tracks[chunk].name)
							MetaEventName.MetaInstrumentName:
								tracks[chunk].instrument = read_string(input_file, length)
								print("Instrument Name: ", tracks[chunk].instrument)
							MetaEventName.MetaLyrics:
								print("Lyrics: ", read_string(input_file, length))
							MetaEventName.MetaMarker:
								print("Marker: ", read_string(input_file, length))
							MetaEventName.MetaCuePoint:
								print("Cue: ", read_string(input_file, length))
							MetaEventName.MetaChannelPrefix:
								print("Prefix: ", input_file.get_8())
							MetaEventName.MetaEndOfTrack:
								end_of_track = true
							MetaEventName.MetaSetTempo:
								# Tempo is in microseconds per quarter note
								if tempo == 0:
									(tempo |= (input_file.get_8() << 16))
									(tempo |= (input_file.get_8() << 8))
									(tempo |= (input_file.get_8() << 0))
									bpm = (60000000 / tempo)
									print("Tempo: ", tempo, " (bpm:", bpm, ")")
							MetaEventName.MetaSMPTEOffset:
								print("SMPTE: H:", input_file.get_8(), " M:", input_file.get_8(),
								" S:", input_file.get_8(), " FR:", input_file.get_8(), " FF:",
								input_file.get_8())
							MetaEventName.MetaTimesSignature:
								print("Time Signature: ", input_file.get_8(), "/", input_file.get_8())
								print("ClocksPerTick: ", input_file.get_8())

								# Midi "Beats" are 24 ticks, sepcify how many 32nd notes constitute a beat
								print("32per24clocks: ", input_file.get_8())
							MetaEventName.MetaKeySignature:
								print("Key Signature: ", input_file.get_8())
								print("Minor Key: ", input_file.get_8())
							MetaEventName.MetaSequencerSpecific:
								print("Sequencer Specific: ", read_string(input_file, length))
							_:
								print("Unrecognised MetaEvent: ", type)
				_:
					print("Unrecognized Status Byte")


	return true

	pass


# Swap byte order of integers as midi was made years ago
# and the byte order have changed over the years.

# Swaps byte order of 32-bit integer
func swap32(n):
	return (((n >> 24) & 0xff) | ((n << 8) & 0xff0000) | ((n >> 8) & 0xff00) | ((n << 24) & 0xff000000))

# swaps byte order of 16-bit integer
func swap16(n):
	return ((n >> 8) | (n << 8))


# Read values from the midi file. Midi has data in on 7 bits
# in a byte. The first bit indicates weather or not to read the rest.

# Read n length bytes from file, and constructs a string.
func read_string(file: File, n) -> String:
	var s := PoolByteArray()
	for _i in range(n): s.append(file.get_8())
	return s.get_string_from_ascii()


func read_value(file: File):
	var val = 0
	var byte = 0

	# Read a byte
	val = file.get_8()

	#Check MSB, if set, read more bytes
	if val & 0x80:
		# Extract bottom 7 bits
		val &= 0x7f

		# Read next byte
		byte = file.get_8()
		# Construct value by setting bottom 7 bits, then shifting 7 bits
		val = (val << 7) | (byte & 0x7F)

		# Loop while MSB is 1
		while byte & 0x80:
			byte = file.get_8()
			val = (val << 7) | (byte & 0x7F)

	# Return final construction
	return val
