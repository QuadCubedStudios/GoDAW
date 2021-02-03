class_name Wave extends Node2D

var data : PoolByteArray = PoolByteArray([]) setget set_data
var zero : Color = Color.black setget set_zero
var wave_color : Color = Color.greenyellow setget set_wave
var x_index : int = 20 setget set_x_index


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


func set_x_index(value : int):
	x_index = value
	update()


func sign_extend(value, bits):
	var sign_bit = 1 << (bits - 1)
	return (value & (sign_bit - 1)) - (value & sign_bit)


func _draw():
	var start = Vector2(0, 0)
	draw_line(Vector2.ZERO, Vector2(5000, 0), zero, 5)
	for i in self.data:
		var end = Vector2(start.x + x_index, sign_extend(-i, 8))
		draw_line(start, end, wave_color, 2)
		start = end
