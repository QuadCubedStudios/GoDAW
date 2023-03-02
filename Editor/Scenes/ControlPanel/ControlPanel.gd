extends Control

signal play()
signal pause()
signal stop()

onready var buttons = {
	"Play": $PlayButton,
	"Pause": $PauseButton,
	"Stop": $StopButton,
	"Add": $AddButton,
}

func _on_PlayButton_pressed():
	emit_signal("play")
	buttons.Play.disabled = true
	buttons.Pause.disabled = false
	buttons.Stop.disabled = false

func _on_PauseButton_pressed():
	emit_signal("pause")
	buttons.Play.disabled = false
	buttons.Pause.disabled = true
	buttons.Stop.disabled = false

func _on_StopButton_pressed():
	emit_signal("stop")
	buttons.Play.disabled = false
	buttons.Pause.disabled = true
	buttons.Stop.disabled = true

func _on_finished(_n = ""):
	yield(get_tree(), "idle_frame")
	buttons.Play.disabled = false
	buttons.Pause.disabled = true
	buttons.Stop.disabled = true

func _on_AddButton_pressed():
	pass # Replace with function body.
