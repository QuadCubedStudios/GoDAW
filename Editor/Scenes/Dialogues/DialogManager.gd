extends Control

onready var progress_dialog: PopupDialog = $ProgressDialog
onready var progress_label:Label = $ProgressDialog/VBoxContainer/Label
onready var progress_bar: ProgressBar = $ProgressDialog/VBoxContainer/ProgressBar

onready var error_dialog: WindowDialog = $ErrorDialog
onready var error_label: Label = $"%ErrorMessage"

onready var file_dialog: FileDialog = $FileDialog

onready var documents_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)

# Progress
func progress(text: String) -> ProgressBar:
	progress_label.text = text
	progress_dialog.popup_centered()
	return progress_bar
func hide_progress(): progress_dialog.hide()

# FileDialog
func file(title: String, mode: int, filters: Array) -> void:
	file_dialog.window_title = title
	file_dialog.mode = mode
	file_dialog.filters = filters
	file_dialog.current_dir = documents_dir
	file_dialog.popup_centered()

# Error
func error(text: String):
	error_label.text = text
	error_dialog.popup_centered()
