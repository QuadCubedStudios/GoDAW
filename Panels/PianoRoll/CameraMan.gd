extends KinematicBody2D

onready var disabled = get_parent().get_node("Disabled/ColorRect")

func _ready():
	set_position(Vector2(0, 500))

func _input(event):
	if !disabled.visible:
		var mouse_pos = get_global_mouse_position()
		if mouse_pos.y > 0 and mouse_pos.x > 0 and mouse_pos.x < 90:
			if event.is_action("scroll_down"):
				if position.y <= Global.piano_roll.spawn_point:
					var _n = move_and_slide(Vector2.DOWN*300)
			if event.is_action("scroll_up"):
				if position.y >= 0:
					var _n = move_and_slide(Vector2.UP*300)
