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
