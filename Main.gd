extends Control

onready var player = $AudioStreamPlayer

func _init():
	pass

func _ready():
	var osc = GoDAW.get_instrument("TripleOsc")
	var wave = Wave.new(osc.create_sample())
	wave.position += Vector2(10, 200)
	add_child(wave)
	# Set stream and play
	player.stream = osc.create_sample()
	player.pitch_scale = 1.0
	player.play()
	pass
