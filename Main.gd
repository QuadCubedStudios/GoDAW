extends Control

var SynthFunctions = preload("./util/scripts/synth_functions.gd")

onready var player = $AudioStreamPlayer

# Function that defines the waveform being played
func sound_function(t):
	# Example function: Adds amplitudes of multiple
	# waveforms

	# Sub-waveforms
	var funcs = [
		SynthFunctions.sine_wave(t, 941.00),
		SynthFunctions.sine_wave(t, 1336.00),
	]

	# Add amplitudes
	var amp = 0
	for f in funcs:
		amp += f

	# Return normalized wave
	return amp / funcs.size()

func _ready():
	# Create sample and set its sample rate
	var sample = AudioStreamSample.new()
	sample.mix_rate = 44100

	# Loop sample if needed (disabled for now)
	sample.loop_mode = AudioStreamSample.LOOP_DISABLED
	sample.loop_begin = 0
	sample.loop_end = sample.mix_rate

	# Prepare samples buffer
	var data = PoolByteArray([])

	# Start sampling
	for t in sample.mix_rate:
		# Call waveform function at each sample interval
		var amplitude = sound_function(float(t) / sample.mix_rate)
		# Store into sample buffer
		data.append(127 * amplitude)

	# Set buffer
	sample.data = data

	# Set stream and play
	player.stream = sample
	player.play()
