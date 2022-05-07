extends Control

onready var loading_dialog: WindowDialog = $DialogBoxes/LoadingDialog
onready var loading_dialog_progress: ProgressBar = $DialogBoxes/LoadingDialog/VBoxContainer/ProgressBar
onready var export_progress: WindowDialog = $DialogBoxes/ExportProgress
onready var export_progress_bar: ProgressBar = $DialogBoxes/ExportProgress/VBoxContainer/ProgressBar
onready var file_dialog: FileDialog = $DialogBoxes/FileDialog
onready var sequencer: Node = $Application/Main/SongEditor/Sequencer
onready var instrument_panel: VBoxContainer = $Application/InstrumentsPanel
onready var documents_dir = OS.get_system_dir(OS.SYSTEM_DIR_DOCUMENTS)

func _on_TopMenu_export_pressed():
	file_dialog.popup_centered()
	file_dialog.current_dir = documents_dir
	var path = yield(file_dialog, "file_selected")

	var recorder = AudioEffectRecord.new()
	AudioServer.add_bus_effect(0, recorder, AudioServer.get_bus_effect_count(0))

	export_progress.popup_centered()
	sequencer.connect("on_note", export_progress_bar, "set_value")
	
	recorder.set_recording_active(true)
	sequencer.play()
	yield(sequencer, "playback_finished")
	recorder.set_recording_active(false)

	var recording = recorder.get_recording()
	recording.save_to_wav(path)
	export_progress.hide()

func _ready():
	# Editor Setup
	
	# Set Font
	var font = get_theme().get_default_font().font_data
	instrument_panel.title.get_font("font", "Label").font_data = font
	
	#load instruments
	loading_dialog.popup()
	GoDAW.connect("loading_progress_max_value_changed", loading_dialog_progress, "set_max")
	GoDAW.connect("loading_progress_value_changed", loading_dialog_progress, "set_value", [loading_dialog_progress.value+1])
	GoDAW.connect("loading_instrument_changed", $DialogBoxes/LoadingDialog/VBoxContainer/Label, "set_text")
	yield(GoDAW.load_instruments(), "completed")
	loading_dialog.hide()
	instrument_panel.reload_instruments()
