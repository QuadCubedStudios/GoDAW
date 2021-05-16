extends AudioStreamPlayer

func play_note(note):
	var transpose = -12
	var pitch = pow(2.0, (transpose + note.p - 64)/12.0)
	self.pitch_scale = pitch
	match note.e:
		GDW_pattern.NOTE_ON:
			self.play()
			if note.t != -1:
				yield(get_tree().create_timer(note.t), "timeout")
				self.stop()
		GDW_pattern.NOTE_OFF:
			self.stop()
#
#func play_c_chord():
#	var transpose = -12
#	var pitch = (pow(2.0, (transpose + 64 - 64)/12.0))
##	self.pitch_scale = pitch
##	yield(get_tree().create_timer(0.5), "timeout")
##	pitch = (pow(2.0, (transpose + 64 - 64)/12.0) +
##				pow(2.0, (transpose + 68 - 64)/12.0))
##	self.pitch_scale = pitch
##	yield(get_tree().create_timer(0.5), "timeout")
#	pitch = (pow(2.0, (transpose + 64 - 64)/12.0) +
#				pow(2.0, (transpose + 68 - 64)/12.0) +
#				pow(2.0, (transpose + 71 - 64)/12.0))
#	var recordingeffectmaster = AudioServer.get_bus_effect(0, 0) #0,0 is first effect on first audio bus
#	recordingeffectmaster.set_recording_active(true)
#	self.stop()
#	print("1 Player OVER")
#	var p1 = AudioStreamPlayer.new()
#	var p2 = AudioStreamPlayer.new()
#	var p3 = AudioStreamPlayer.new()
#	yield(get_tree().create_timer(0.5), "timeout")
#	add_child(p1)
#	add_child(p2)
#	add_child(p3)
#	p1.stream = stream
#	p2.stream = stream
#	p3.stream = stream
#	p1.pitch_scale = pow(2.0, (transpose + 64 - 64)/12.0)
#	p2.pitch_scale = pow(2.0, (transpose + 68 - 64)/12.0)
#	p3.pitch_scale = pow(2.0, (transpose + 71 - 64)/12.0)
#	var vol = linear2db(0.1)
#	p1.volume_db = vol
#	p2.volume_db = vol
#	p3.volume_db = vol
#	print(vol)
#	p1.play()
#	p2.play()
#	p3.play()
#	yield(get_tree().create_timer(2), "timeout")
#	p1.stop()
#	p2.stop()
#	p3.stop()
#	var final_recording = recordingeffectmaster.get_recording()  #to grab recording
#	final_recording.save_to_wav("res://output.waw")
