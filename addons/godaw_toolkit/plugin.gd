tool
extends EditorPlugin

const ADDON_PATH = "res://addons/godaw_toolkit"

func _enter_tree():
	self.add_autoload_singleton("GoDAW", "%s/API/GoDAW.gd" % ADDON_PATH)

func _exit_tree():
	self.remove_autoload_singleton("GoDAW")
