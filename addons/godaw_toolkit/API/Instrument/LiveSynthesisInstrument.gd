extends Instrument

class_name LiveSynthesisInstrument

var player: AudioStreamPlayer
var playback: AudioStreamGeneratorPlayback
var mix_rate: float

var t := 0.0

func _init(instrument_name: String, mix_rate: float = 44100.0).(instrument_name):
	self.mix_rate = mix_rate

func _ready():
	self.player = self.get_new_player()
	var stream = AudioStreamGenerator.new()
	stream.buffer_length = 0.04
	stream.mix_rate = self.mix_rate
	self.player.stream = stream

func _process(delta):
	if player.playing:
		_fill_buffer()

func _fill_buffer():
	var buffer = PoolVector2Array()
	self.playback = self.player.get_stream_playback()
	for _i in self.playback.get_frames_available():
		buffer.append(Vector2.ONE * waveform(t))
		t += 1 / self.mix_rate

	self.playback.push_buffer(buffer)

func waveform(t: float) -> float:
	return 0.0

func play_note(_note: Note):
	_fill_buffer()
	player.play()

func stop_note(_note: Note):
	player.stop()
	yield(player, "finished")
	playback.clear_buffer()
