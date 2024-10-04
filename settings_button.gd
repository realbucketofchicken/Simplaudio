extends Button

@onready var settings_popup: Control = $"../SettingsPopup"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_pressed() -> void:
	if settings_popup.visible:
		settings_popup.hide()
	else:
		settings_popup.show()
