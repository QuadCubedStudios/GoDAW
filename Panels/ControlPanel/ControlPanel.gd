extends Control

onready var buttons = {
	"Play": $PlayButton,
	"Pause": $PauseButton,
	"Stop": $StopButton,
	"Add": $AddButton,
}

func _ready():
	Global.connect("finished", self, "_on_finished")

func _on_PlayButton_pressed():
	Global.emit_signal("play")
	buttons.Play.disabled = true
	buttons.Pause.disabled = false
	buttons.Stop.disabled = false


func _on_PauseButton_pressed():
	Global.emit_signal("pause")
	buttons.Play.disabled = false
	buttons.Pause.disabled = true
	buttons.Stop.disabled = false


func _on_StopButton_pressed():
	Global.emit_signal("stop")
	buttons.Play.disabled = false
	buttons.Pause.disabled = true
	buttons.Stop.disabled = true

func _on_finished():
	buttons.Play.disabled = false
	buttons.Pause.disabled = true
	buttons.Stop.disabled = true

func _on_AddButton_pressed():
	pass # Replace with function body.
