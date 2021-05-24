extends Panel

func _on_PlayButton_pressed():
	Global.emit_signal("play")


func _on_PauseButton_pressed():
	Global.emit_signal("pause")


func _on_StopButton_pressed():
	Global.emit_signal("stop")


func _on_AddButton_pressed():
	pass # Replace with function body.
