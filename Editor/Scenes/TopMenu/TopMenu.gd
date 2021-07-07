extends HBoxContainer

var menus = {
	"File": {
		"node": "FileMenu",
		"elements": { "Open": "_open", "Save": "", "Save as...": "", "New": "", "Separator": "", "Quit": "" }
	},
	"Edit": {
		"node": "EditMenu",
		"elements": { }
	},
	"View": {
		"node": "ViewMenu",
		"elements": {  }
	},
	"Help": {
		"node": "HelpMenu",
		"elements": {  }
	}
}
onready var file_menu = $FileMenu
onready var edit_menu = $EditMenu
onready var view_menu = $ViewMenu
onready var help_menu = $HelpMenu

func _ready():
	for menu in menus:
		var m = menus[menu]
		var node = get_node(m.node)
		init_menu(node, m.elements)
		node.get_popup().connect("id_pressed", self, "on_item_pressed", [menu])

func on_item_pressed(id, menu):
	var menu_dic = menus[menu]
	var node = get_node(menu_dic.node)

	var item_name = node.get_popup().get_item_text(id)
	var func_to_call = menu_dic["elements"][item_name]

	if self.has_method(func_to_call):
		self.call(func_to_call)
	else:
		push_error("NO METHOD CALLED " + func_to_call + " FOUND IN " + self.name)

func _open():
	print("Opened")

func init_menu(menu, items):
	for e in items:
		if e == "Separator":
			menu.get_popup().add_separator("")
			continue
		menu.get_popup().add_item(e)
