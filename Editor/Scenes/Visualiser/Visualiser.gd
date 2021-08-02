extends HBoxContainer

func _on_play():
	$Spectrum.playing = true

func _on_finished():
	$Spectrum.playing = false
