extends Reference

class_name OSC


enum { SAW,SIN, NSE, SQR, TRI }


# Standard Sine Wave:
# y(t) = sin(2*pi*f*t)
static func osc(t, freq, type) -> float:
	match type:
		SAW: return fmod(2 * freq * t, 2) - 1
		SIN: return sin(2 * PI * freq * t)
		NSE: return (randf() * 2) - 1
		SQR: return sign(osc(t, freq, SIN))
		TRI: return abs(2 * osc(t, freq, SAW)) - 1
		_: return 0.0
