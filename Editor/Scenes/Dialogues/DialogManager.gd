extends Control

onready var progress_dialog:WindowDialog = $ProgressDialog
onready var progress_label:Label = $ProgressDialog/VBoxContainer/Label
onready var progress_bar: ProgressBar = $ProgressDialog/VBoxContainer/ProgressBar

onready var file_dialog: FileDialog = $FileDialog
onready var documents_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)

# Progress
func progress(title:String, text: String) -> ProgressBar:
	progress_dialog.window_title = title
	progress_label.text = text
	progress_dialog.popup_centered()
	return progress_bar
func hide_progress(): progress_dialog.hide()

# FileDialog
func get_file() -> String:
	file_dialog.popup_centered()
	file_dialog.current_dir = documents_dir
	return yield(file_dialog, "file_selected")
