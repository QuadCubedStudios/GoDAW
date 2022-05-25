class_name Project extends Resource

enum PROJECT_TYPE {
	GUI,
	SONGSCRIPT,
}

var project_name: String
var project_type: int
var song_sequence: SongSequence
var song_script: String

func _init( name = "Untitled Song", type = PROJECT_TYPE.GUI ):
	project_name = name
	project_type = type

func rename( new_name ):
	project_name = new_name

func set_song( song ):
	song = song

func set_script( script ):
	song_script = script
