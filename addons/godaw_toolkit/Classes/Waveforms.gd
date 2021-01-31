extends Reference

class_name Waveforms

# Standard Sine Wave:
# y(t) = sin(2*pi*f*t)
static func sine(t, freq):
	return sin(2 * PI * freq * t)

static func triangle(t, freq):
	return abs(2 * saw(t, freq)) - 1

static func square(t, freq):
	return sign(sine(t, freq))

static func saw(t, freq):
	return fmod(2 * freq * t, 2) - 1

static func noise(mix_rate, t):
	return (randf() * 2) - 1
