extends Panel

var text: String setget set_text
var icon: Resource setget set_icon
var player: AudioStreamPlayer
var player_scn: PackedScene = preload("res://util/Player.tscn")

func init(ico: Resource, instrument_name: String):
	set_text(instrument_name)
	set_icon(ico)
	player = player_scn.instance()
	player.stream = GoDAW.get_instrument(text).create_sample()
	Global.players.add_child(player)

func set_text(val: String):
	text = val
	$HBox/Label.text = val

func set_icon(val: Resource):
	icon = val
	$HBox/TextureRect.set_texture(val)
