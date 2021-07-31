extends Instrument

# Taken from the DTMF Wikipedia article
const FR1 = 697
const FR2 = 770
const FR3 = 852
const FR4 = 941

const FC1 = 1209
const FC2 = 1336
const FC3 = 1477
const FC4 = 1633

var DTMF_TONES = {
	"1": [FR1, FC1],
	"2": [FR1, FC2],
	"3": [FR1, FC3],
	"A": [FR1, FC4],

	"4": [FR2, FC1],
	"5": [FR2, FC2],
	"6": [FR2, FC3],
	"B": [FR2, FC4],

	"7": [FR3, FC1],
	"8": [FR3, FC2],
	"9": [FR3, FC3],
	"C": [FR3, FC4],

	"*": [FR4, FC1],
	"0": [FR4, FC2],
	"#": [FR4, FC3],
	"D": [FR4, FC4],
}

func _init().("DTMF"):
	# Replace all tones with their corresponding samples
	for tone in DTMF_TONES:
		var data = PoolByteArray([])
		var sample = AudioStreamSample.new()
		sample.loop_mode = AudioStreamSample.LOOP_FORWARD
		sample.loop_begin = 0
		# TODO: This could be much shorter. Try to stop it at one cycle
		sample.loop_end = sample.mix_rate

		# TODO: This code is duplicated from Piano.gd. Make a utility method for
		# sample generation
		for t in sample.loop_end:
			# Call waveform function at each sample interval
			t = float(t) / sample.mix_rate
			var amplitude = (
				Waveforms.sine(t, DTMF_TONES[tone][0]) +
				Waveforms.sine(t, DTMF_TONES[tone][1])
			) / 2
			# Store into sample buffer
			data.append(127 * amplitude)

		sample.data = data
		DTMF_TONES[tone] = sample

func play_note(note):
	$AudioStreamPlayer.stream = DTMF_TONES[note.instrument_data]
	$AudioStreamPlayer.play()
	yield(get_tree().create_timer(note.duration), "timeout")

	$AudioStreamPlayer.stop()
