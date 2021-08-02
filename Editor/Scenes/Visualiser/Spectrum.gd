extends Control

const VU_COUNT = 200
const FREQ_MAX = 20000.00
const MIN_DB = 100

var spectrum: AudioEffectSpectrumAnalyzerInstance
var img_input: Image
var tex := ImageTexture.new()
var playing := false

func _init():
	AudioServer.add_bus_effect(0, AudioEffectSpectrumAnalyzer.new(), 0)
	spectrum = AudioServer.get_bus_effect_instance(0, 0)
	img_input = Image.new()
	img_input.create(VU_COUNT, 1, false, Image.FORMAT_RF)

	tex = ImageTexture.new()
	tex.create_from_image(img_input)

	self.material.set_shader_param("BAR_MAGNITUDES", tex)

func _process(_delta):
	if playing:
		var prev_hz = 0
		img_input.lock()
		for i in range(1, VU_COUNT + 1):
			var hz = i * FREQ_MAX / VU_COUNT
			var f = spectrum.get_magnitude_for_frequency_range(prev_hz, hz)
			var energy = clamp(
				(MIN_DB + linear2db(f.length())) / MIN_DB,
				0, 1
			)
			img_input.set_pixel(i - 1, 0, Color(energy, 0.0, 0.0))
			prev_hz = hz
		img_input.unlock()
		tex.set_data(img_input)
