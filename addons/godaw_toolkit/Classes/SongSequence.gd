class_name SongSequence extends Resource

#Tempo in bpm
export var tracks: Array = []
export var tempo: int = 0 setget set_tempo
export var master_pitch: int = 1 setget set_pitch
export var master_volume: int = linear2db(0.5) setget set_volume

# setter functions
func set_tempo(val: int):
	tempo = val

func set_pitch(val: int):
	master_pitch = val

func set_volume(val: int):
	master_volume = linear2db(val)

func add_track(val: Track):
	tracks.append(val)
