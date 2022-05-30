extends ConfirmationDialog

signal new_project(project)

onready var project_name = $HBox/data/ProjectName
onready var project_type = $HBox/data/ProjectType

func _ready():
	project_type.add_item("GUI", Project.PROJECT_TYPE.GUI)
	project_type.add_item("SongScript", Project.PROJECT_TYPE.SONGSCRIPT)

func _confirmed():
	emit_signal("new_project", Project.new(project_name.text, project_type.selected))
