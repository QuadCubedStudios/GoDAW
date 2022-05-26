extends ConfirmationDialog

signal new_project(project)

onready var project_name = $VBox/ProjectName/LineEdit
onready var project_type = $VBox/ProjectType/OptionButton

func _ready():
	project_type.add_item("GUI", Project.PROJECT_TYPE.GUI)
	project_type.add_item("SongScript", Project.PROJECT_TYPE.SONGSCRIPT)

func _confirmed():
	emit_signal("new_project", Project.new(project_name.text, project_type.selected))
