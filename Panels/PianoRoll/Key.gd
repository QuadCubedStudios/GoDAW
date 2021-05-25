extends Button

var key_no: int
var player: AudioStreamPlayer

func _ready():
	var _n = connect("button_up", self, "stop")
	_n = connect("button_down", self, "start")

func stop():
	player.queue_free()

func start():
	print(key_no)
	player = Global.players.play(Global.selected_instrument, key_no)
