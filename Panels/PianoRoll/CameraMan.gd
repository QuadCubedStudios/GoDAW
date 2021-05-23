extends KinematicBody2D

onready var disabled = get_node("../../../PianoContainer/PianoViewport/Disabled/ColorRect")

func _ready():
	set_position(Vector2(0, 672))

func _input(event):
	if !disabled.visible:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.y > -90 and mouse_pos.x > 0:
			if event.is_action("scroll_down"):
				if position.y <= Global.piano_roll.spawn_point-390:
					set_position(get_position()+Vector2.DOWN*14)
					Global.piano_roll.grid.set_scroll(-1)
			if event.is_action("scroll_up"):
				if position.y >= 5:
					set_position(get_position()+Vector2.UP*14)
					Global.piano_roll.grid.set_scroll(1)
