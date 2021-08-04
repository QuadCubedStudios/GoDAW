extends Instrument

# Taken from the DTMF Wikipedia article
const FREQ_ROWS = [697, 770, 852, 941]
const FREQ_COLS = [1209, 1336, 1477, 1633]

var DTMF_TONES = {}

func _init().("DTMF"):
	var KEYS = [
		["1", "2", "3", "A"],
		["4", "5", "6", "B"],
		["7", "8", "9", "C"],
		["*", "0", "#", "D"],
	]
	for row in 4:
		for col in 4:
			var sample = SampleTools.new(0.5)
			var sample_end = sample.total_sample_count()
			var mix_rate = sample.mix_rate()

			for t in sample_end:
				# Call waveform function at each sample interval
				t = float(t) / mix_rate
				sample.append_data(
					(
						Waveforms.sine(t, FREQ_ROWS[row], 0) +
						Waveforms.sine(t, FREQ_COLS[col], 0)
					) / 2
				)

			DTMF_TONES[KEYS[row][col]] = sample.as_sample()

func _ready():
	$AudioStreamPlayer.bus = AudioServer.get_bus_name(bus_idx)

func play_note(note):
	$AudioStreamPlayer.stream = DTMF_TONES[note.instrument_data]
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(note.duration), "timeout")

	$AudioStreamPlayer.stop()
