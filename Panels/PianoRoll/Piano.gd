extends Control

var white_key = preload("res://Panels/PianoRoll/WhiteKey.tscn")
var black_key = preload("res://Panels/PianoRoll/BlackKey.tscn")
onready var key_container = $Keys/KeyContainer
export var semitones : int = 5
const SEMITONE_FACTOR = pow(2, 1.0/12)

func _ready():
	for _i in range(semitones):
		add_semitone()
	for i in key_container.get_children():
		i.connect("key_pressed", self, "play")
	key_container.move_child(key_container.get_child(0), key_container.get_child_count())

func add_semitone():
	for _i in range(7):
		var key = white_key.instance()
		key_container.add_child(key)
	for i in range(5):
		var key = black_key.instance()
		key_container.add_child(key)
		key_container.move_child(key, key.get_index()- (i+1*i if i < 2 else 1+2*i))
	pass

func play(key_no):
	print(key_no)
	var player : AudioStreamPlayer = get_node("/root/Main").player
	player.pitch_scale = to_hertz(key_no)/440
	player.play()

func to_hertz(key_no):
	return pow(SEMITONE_FACTOR, (key_no - 49)) * 440
