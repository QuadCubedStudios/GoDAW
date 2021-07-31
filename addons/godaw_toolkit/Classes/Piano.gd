extends Instrument

const OCTAVE_FACTOR = pow(2, 1.0/12)

var player: AudioStreamPlayer
var play_timer: Timer

func _init(instrument_name: String).(instrument_name):
	player = AudioStreamPlayer.new()
	player.stream = create_sample(440.00)
	play_timer = Timer.new()

func _ready():
	add_child(play_timer)
	add_child(player)

func play_note(note):
	player.pitch_scale = (to_hertz(note.instrument_data.key) / 440.00)
	player.play()

	play_timer.start(note.duration)
	yield(play_timer, "timeout")

	player.stop()

func to_hertz(key_no):
	return pow(OCTAVE_FACTOR, (key_no - 69)) * 440

func create_sample(freq: float) -> AudioStreamSample:
	# Create sample and set its sample rate
	var sample = SampleTools.new(1.0)
	var sample_end = sample.total_sample_count()
	var mix_rate = sample.mix_rate()

	# Start sampling
	for t in sample_end:
		# Call waveform function at each sample interval
		var amplitude = self.waveform(float(t) / mix_rate, freq)
		# Store into sample buffer
		sample.append_data(amplitude)

	return sample.as_sample()

func waveform(t: float, freq: float) -> float:
	return 0.0
