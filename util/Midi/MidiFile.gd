extends Reference

enum EventName {
	VoiceNoteOff = 0x80,
	VoiceNoteOn = 0x90,
	VoiceAftertouch = 0xA0,
	VoiceControlChange = 0xB0
	VoiceProgramChange = 0xC0
	VoiceChannelPressure = 0xD0
	VoicePitchBend = 0xE0
	SystemExclusive = 0xF0
	}

func new(filename: String = ""):
	if filename != "": parse_file(filename)
	pass

func parse_file(filename: String = "") -> bool:
	# Open file, if any errors return false
	var input_file = File.new()
	var err = input_file.open(filename)
	if err:
		return false

	# Parse MIDI File

	# Read the header of MIDI File
	var _file_id = swap32(input_file.get_u32())
	var _header_length = swap32(input_file.get_u32())
	var _format = swap16(input_file.get_u16())
	var track_chunks = swap16(input_file.get_u16())
	var _division = swap16(input_file.get_u16())

	# Read data from the MIDI File
	for chunk in range(track_chunks):
		print("++New Track++")
		# Read Track Header
		var track_id = swap32(input_file.get_u32())
		var track_lenght = swap32(input_file.get32())

		var end_of_track = false
		var previous_status = 0

		while !input_file.eof_reached() && end_of_track:
			# All MIDI Events contain a timecode and a status byte
			var status_time_delta = 0
			var status = 0

			# Read Timecode
			status_time_delta = read_value(input_file)
			status = input_file.get_u8()

			if status < 0x80:
				status = previous_status
				input_file.seek(input_file.get_position()-1)

			# Match on the event.
			match (status & 0xF0):
				EventName.VoiceNoteOff:
					previous_status = status
					var channel = status & 0x0F
					var note_id = input_file.get_u8()
					var note_velocity = input_file.get_u8()

				EventName.VoiceNoteOn:
					previous_status = status
					var channel = status & 0x0F
					var note_id = input_file.get_u8()
					var note_velocity = input_file.get_u8()
				EventName.VoiceAftertouch:
					previous_status = status
					var channel = status & 0x0F
					var note_id = input_file.get_u8()
					var note_velocity = input_file.get_u8()
				EventName.VoiceControlChange:
					previous_status = status
					var channel = status & 0x0F
					var note_id = input_file.get_u8()
					var note_velocity = input_file.get_u8()
				EventName.VoiceChannelPressure:
					previous_status = status
					var channel = status & 0x0F
					var channel_pressure = input_file.get_u8()
				EventName.VoicePitchBend:
					previous_status = status
					var channel = status & 0x0F
					var LS7B = input_file.get_u8()
					var MS7B = input_file.get_u8()
				EventName.SystemExclusive: pass
				_ :
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
	for _i in range(n): s.append(file.get_u8())
	return s.get_string_from_ascii()


func read_value(file: File):
	var val = 0
	var byte = 0

	# Read a byte
	val = file.get_u8()

	#Check MSB, if set, read more bytes
	if val & 0x80:
		# Extract bottom 7 bits
		val &= 0x7f

		# Read next byte
		byte = file.get_u8()
		# Construct value by setting bottom 7 bits, then shifting 7 bits
		val = (val << 7) | (byte & 0x7F)

		# Loop while MSB is 1
		while byte & 0x80:
			byte = file.get_u8()
			val = (val << 7) | (byte & 0x7F)

	# Return final construction
	return val
