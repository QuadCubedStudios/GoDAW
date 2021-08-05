tool
extends EditorScript

func _run():
	var theme: Theme = load("res://Themes/Default/GoDAWTheme.tres")
	var node_type = "VSplitContainer"

	var icons = theme.get_icon_list(node_type)
	for icon in icons:
		var tex: ImageTexture = theme.get_icon(icon, node_type)
		tex.get_data().save_png("res://Themes/Default/ButtonIcons/%s.png" % icon)
