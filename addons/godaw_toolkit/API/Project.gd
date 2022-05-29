class_name Project extends Resource

enum PROJECT_TYPE {
	GUI,
	SONGSCRIPT,
}

export var project_name: String
export var project_type: int
export var song_sequence: Resource
export var song_script: String
export var saved: bool = false

func _init( name: String = "", type = PROJECT_TYPE.GUI ):
	project_name =  "Untitled Song" if name.empty() else name
	project_type = type
