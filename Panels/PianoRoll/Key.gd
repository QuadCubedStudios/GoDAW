extends Button

var key_no: int

func _ready():
	connect("button_up", self, "stop")
	connect("button_down", self, "start")

func stop():
	var player_idx = Global.selected_instrument.get_index()-2
	var player = Global.players.get_child(player_idx)
	player.stop()

func start():
	var player_idx = Global.selected_instrument.get_index()-2
	var player = Global.players.get_child(player_idx)
	player.play_note({'e':0,'p':key_no, 't':-1, 'v':127})
