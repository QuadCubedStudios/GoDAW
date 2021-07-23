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
	var sample = AudioStreamSample.new()
	sample.mix_rate = 44100 #self.sample_rate

	# Loop sample if needed
	sample.loop_mode = AudioStreamSample.LOOP_FORWARD
	sample.loop_begin = 0
	sample.loop_end = floor(sample.mix_rate)

	# Prepare samples buffer
	var data = PoolByteArray([])

	# Start sampling
	for t in sample.mix_rate:
		# Call waveform function at each sample interval
		var amplitude = self.waveform(float(t) / sample.mix_rate, freq)
		# Store into sample buffer
		data.append(127 * amplitude)

	# Set buffer
	sample.data = data
	return sample

func waveform(t: float, freq: float) -> float:
	return 0.0
