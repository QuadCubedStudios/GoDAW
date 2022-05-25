extends Control

onready var dialog_manager: Control = $DialogManager
onready var sequencer: Node = $Application/Main/SongEditor/Sequencer
onready var instrument_panel: VBoxContainer = $Application/InstrumentsPanel

var project: Project

signal project_changed(project)

func _on_TopMenu_export_pressed():
	var file_path = dialog_manager.get_file() 
	var recorder = AudioEffectRecord.new()
	var progress = dialog_manager.progress("Exporting", "Exporting...")
	
	AudioServer.add_bus_effect(0, recorder, AudioServer.get_bus_effect_count(0))
	sequencer.connect("on_note", progress, "set_value")
	recorder.set_recording_active(true)
	sequencer.play()
	yield(sequencer, "playback_finished")
	recorder.set_recording_active(false)

# Save recording
	var recording = recorder.get_recording()
	recording.save_to_wav(file_path)
	dialog_manager.hide_progress()

func _ready():
	# Editor Setup
	
	# Set Font
	var font = get_theme().get_default_font().font_data
	instrument_panel.title.get_font("font", "Label").font_data = font
	
	#load instruments
	var progress = dialog_manager.progress("Loading", "Loading...")
	var _n = GoDAW.connect("loading_progress_max_value_changed", progress, "set_max")
	_n = GoDAW.connect("loading_progress_value_changed", progress, "set_value", [progress.value+1])
	_n = GoDAW.connect("loading_instrument_changed", dialog_manager.progress_label, "set_text")
	yield(GoDAW.load_instruments(), "completed")
	dialog_manager.hide_progress()
	instrument_panel.reload_instruments()

	#Project setup
	set_project(Project.new())

func set_project(new_project):
	project = new_project
	emit_signal("project_changed", project)
