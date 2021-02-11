class_name Wave extends Node2D

var data : PoolByteArray = PoolByteArray([]) setget set_data
var zero : Color = Color.black setget set_zero
var wave_color : Color = Color.greenyellow setget set_wave

func _init(audio : AudioStreamSample):
	data = audio.data
	update()


func set_data(value : PoolByteArray):
	data = value
	update()


func set_zero(value : Color):
	zero = value
	update()


func set_wave(value : Color):
	wave_color = value
	update()

func sign_extend(value, bits):
	var sign_bit = 1 << (bits - 1)
	return (value & (sign_bit - 1)) - (value & sign_bit)


func _draw():
	var start = Vector2(0, 0)
	draw_line(Vector2.ZERO, Vector2(5000, 0), zero, 5)
	for i in self.data.size():
		var end = Vector2(start.x + (10 * i / float(self.data.size())), sign_extend(-self.data[i], 8))
		draw_line(start, end, wave_color, 2)
		start = end
