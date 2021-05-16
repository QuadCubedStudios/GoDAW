extends Button

var key_no: int

func _ready():
	var _n = connect("button_up", self, "stop")
	_n = connect("button_down", self, "start")

func stop():
	print(key_no)
	var player_idx = Global.selected_instrument.get_index()-2
	var player = Global.players.get_child(player_idx)
	player.stop()

func start():
	var player_idx = Global.selected_instrument.get_index()-2
	var player = Global.players.get_child(player_idx)
	player.play_note({'e':0,'p':key_no, 't':-1, 'v':127})
