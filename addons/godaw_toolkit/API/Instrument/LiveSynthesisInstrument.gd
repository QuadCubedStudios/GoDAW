extends Instrument

class_name LiveSynthesisInstrument

var player: AudioStreamPlayer
var t := 0.0
var playback: AudioStreamGeneratorPlayback

func _init(instrument_name: String).(instrument_name):
	pass

func _ready():
	self.player = self.get_new_player()
	var stream = AudioStreamGenerator.new()
	stream.buffer_length = 0.04
	self.player.stream = stream

func _process(delta):
	if player.playing:
		_fill_buffer()

func _fill_buffer():
	var buffer = PoolVector2Array()
	self.playback = self.player.get_stream_playback()
	for _i in self.playback.get_frames_available():
		buffer.append(Vector2.ONE * waveform(t))
		t += 1 / 44100.0

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
