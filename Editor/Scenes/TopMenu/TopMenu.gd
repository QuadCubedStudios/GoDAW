extends HBoxContainer

signal new_pressed()
signal export_pressed()

onready var menus = {
	"Song": {
		"node": $SongMenu,
		"elements": { "New": "new_pressed", "Open": "", "Save": "", "Save as...": "", "Export": "export_pressed" ,"Separator": "", "Quit": "" }
	},
	"Edit": {
		"node": $EditMenu,
		"elements": { }
	},
	"View": {
		"node": $ViewMenu,
		"elements": {  }
	},
	"Help": {
		"node": $HelpMenu,
		"elements": {  }
	}
}

func _ready():
	for menu in menus:
		var m = menus[menu]
		var node = m.node
		init_menu(node, m.elements)
		node.get_popup().connect("id_pressed", self, "on_item_pressed", [menu])

func project_changed(project):
	$ProjectName.text = project.project_name

func on_item_pressed(id, menu):
	var menu_dict = menus[menu]
	var node = menu_dict.node
	var item_name = node.get_popup().get_item_text(id)
	var s = menu_dict["elements"][item_name]
	emit_signal(s)

func init_menu(menu, items):
	for e in items:
		if e == "Separator":
			menu.get_popup().add_separator("")
			continue
		menu.get_popup().add_item(e)
