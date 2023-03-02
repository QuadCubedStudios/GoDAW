extends Control

onready var dialog_manager: Control = $DialogManager
onready var song_editor: Node = $Application/Main/SongEditor
onready var sequencer: Node = $Application/Main/SongEditor/Sequencer
onready var instrument_panel: VBoxContainer = $Application/InstrumentsPanel

var project: Project

signal project_changed(project)

func _on_TopMenu_export_pressed():
	dialog_manager.file("Export", FileDialog.MODE_SAVE_FILE, ["*.wav ; Wav Files"])
	var file_path = yield(dialog_manager.file_dialog, "file_selected") 
	song_editor.sequence()
	var recorder = AudioEffectRecord.new()
	AudioServer.add_bus_effect(0, recorder, AudioServer.get_bus_effect_count(0))
	
	var progress = dialog_manager.progress("Exporting...")
	progress.max_value = 100
	sequencer.connect("on_note", progress, "set_value")
	
	recorder.set_recording_active(true)
	sequencer.play()
	yield(sequencer, "playback_finished")
	recorder.set_recording_active(false)

# Save recording
	var recording = recorder.get_recording()
	recording.save_to_wav(file_path)
	dialog_manager.hide_progress()

func _save(file_path):
	project.song_script = song_editor.song_script_editor.text
	ResourceSaver.save(file_path, project)

func _load(file_path):
	set_project(ResourceLoader.load(file_path))

func _on_TopMenu_save_pressed():
	if project.saved:
		_save(project.resource_path)
	else: _on_TopMenu_save_as_pressed()

func _on_TopMenu_save_as_pressed():
	dialog_manager.file("Save", FileDialog.MODE_SAVE_FILE, ["*.tres; Godot Text Resource FIle", "*res; Godot Resoruce File"])
	project.saved = true
	var file_path = yield(dialog_manager.file_dialog, "file_selected") 
	_save(file_path)

func _on_TopMenu_open_pressed():
	dialog_manager.file("Open", FileDialog.MODE_OPEN_FILE, ["*.tres; Godot Text Resource FIle", "*res; Godot Resoruce File"])
	var file_path = yield(dialog_manager.file_dialog, "file_selected") 
	_load(file_path)

func _ready():
	# Editor Setup
	
	# Set Font
	var font = get_theme().get_default_font().font_data
	instrument_panel.title.get_font("font", "Label").font_data = font
	
	# Load instruments
	var progress = dialog_manager.progress("Loading...")
	var _n = GoDAW.connect("loading_progress_max_value_changed", progress, "set_max")
	_n = GoDAW.connect("loading_progress_value_changed", progress, "set_value", [progress.value+1])
	_n = GoDAW.connect("loading_instrument_changed", dialog_manager.progress_label, "set_text")
	yield(GoDAW.load_instruments(), "completed")
	dialog_manager.hide_progress()
	instrument_panel.reload_instruments()

	# Clear song history.
	var dir = Directory.new()
	dir.open("user://")
	if dir.file_exists("song.gd"):
		dir.remove("song.gd")

	# Project setup
	set_project(Project.new())

func set_project(new_project):
	project = new_project
	emit_signal("project_changed", project)

