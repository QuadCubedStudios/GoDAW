extends Object

# Standard Sine Wave:
# y(t) = sin(2*pi*f*t)
static func sine_wave(t, freq):
	return sin(2 * PI * freq * t)

static func triangle_wave(t, freq):
	return asin(sine_wave(t, freq))

static func square_wave(t, freq):
	return sign(sine_wave(t, freq))

static func saw_wave(t, freq):
	return fmod(2 * PI * freq * t, 1)

static func noise(mix_rate, t):
	return randf()
