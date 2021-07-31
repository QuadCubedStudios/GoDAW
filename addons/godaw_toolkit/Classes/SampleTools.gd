extends Reference

class_name SampleTools

var sample: AudioStreamSample
var data: PoolByteArray

func _init(sample_duration: float, mix_rate: int = 44100):
	self.data = PoolByteArray([])
	self.sample = AudioStreamSample.new()

	self.sample.mix_rate = mix_rate
	self.sample.loop_mode = AudioStreamSample.LOOP_FORWARD
	self.sample.loop_begin = 0
	self.sample.loop_end = int(sample_duration * mix_rate)

func mix_rate() -> int:
	return self.sample.mix_rate

func total_sample_count() -> int:
	return int(self.sample.loop_end)

func append_data(amplitude: float):
	self.data.append(127 * amplitude)

func as_sample() -> AudioStreamSample:
	self.sample.data = data
	return self.sample
