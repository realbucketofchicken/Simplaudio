extends Button

@onready var settings_popup: Control = $"../SettingsHolder/SettingsPopup"
var currentlyExtending:bool
var Target:float = 50

func _process(delta: float) -> void:
	if currentlyExtending:
		settings_popup.position.y = clamp(lerp(settings_popup.position.y,Target,0.25),0,100)
	else:
		settings_popup.position.y -=1
		settings_popup.position.y = clamp(lerp(Target,settings_popup.position.y,1.25),0,100)
	settings_popup.modulate.a = settings_popup.position.y / Target
	if settings_popup.position.y > 1:
		settings_popup.show()
	else:
		settings_popup.hide()

func _on_toggled(toggled_on: bool) -> void:
	print("@@")
	if toggled_on:
		currentlyExtending = true
		settings_popup.position.y = 1
	else:
		currentlyExtending = false
