extends Node

const OCTAVE_FACTOR = pow(2, 1.0/12)

func play(instrument: String, key_no: int) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.stream = GoDAW.get_instrument(instrument).create_sample(to_hertz(key_no))
	add_child(player)
	player.play()
	return player

func to_hertz(key_no):
	return pow(OCTAVE_FACTOR, (key_no - 49)) * 440
