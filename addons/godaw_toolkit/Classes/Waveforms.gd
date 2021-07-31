extends Reference

class_name Waveforms

# Standard Sine Wave:
# y(t) = sin(2*pi*f*t)
static func sine(t, freq, phase):
	return sin(2 * PI * freq * t + phase)

static func triangle(t, freq, phase):
	return abs(2 * saw(t, freq, phase)) - 1

static func square(t, freq, phase):
	return sign(sine(t, freq, phase))

static func saw(t, freq, phase):
	return fmod(2 * freq * t + phase, 2) - 1

static func noise(t, freq, phase):
	return (randf() * 2) - 1
