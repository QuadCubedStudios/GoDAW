extends KinematicBody2D

func _input(event):
	if event.is_action("scroll_down"):
			move_and_slide(Vector2.DOWN*300)
	if event.is_action("scroll_up"):
		if position.y >= 0:
			move_and_slide(Vector2.UP*300)
