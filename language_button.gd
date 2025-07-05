extends MenuButton

@export var settings:Settings

func _ready() -> void:
	for trans_language in  TranslationServer.get_loaded_locales():
		get_popup().add_item(trans_language)
	get_popup().id_pressed.connect(got_pressed)
	

func got_pressed(id:int) -> void:
	settings.Parent.overridden_locale = get_popup().get_item_text(id)
	TranslationServer.set_locale(get_popup().get_item_text(id))
	settings.Parent.SaveEverything()
