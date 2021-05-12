extends Panel

func init(icon: Resource, instrument_name: String):
	$HBox/TextureRect.set_texture(icon)
	$HBox/Label.text = instrument_name
