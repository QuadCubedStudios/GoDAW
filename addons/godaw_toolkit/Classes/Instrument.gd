extends Reference

class_name Instrument

var instrument_name
var sample_length
var sample_rate

func _init(instrument_name: String, sample_length: float = 1, sample_rate: int = 44100):
	self.instrument_name = instrument_name
	self.sample_length = sample_length
	self.sample_rate = sample_rate

func waveform(t: float) -> int:
	return 0

func create_sample() -> AudioStreamSample:
	# Create sample and set its sample rate
	var sample = AudioStreamSample.new()
	sample.mix_rate = self.sample_rate

	# Loop sample if needed
	sample.loop_mode = AudioStreamSample.LOOP_DISABLED
	sample.loop_begin = 0
	sample.loop_end = floor(self.sample_length * self.sample_rate)

	# Prepare samples buffer
	var data = PoolByteArray([])

	# Start sampling
	for t in sample.mix_rate:
		# Call waveform function at each sample interval
		var amplitude = self.waveform(float(t) / sample.mix_rate)
		# Store into sample buffer
		data.append(127 * amplitude)

	# Set buffer
	sample.data = data
	return sample
