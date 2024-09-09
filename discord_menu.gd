extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#await get_tree().create_timer(0.3).timeout
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggled(toggled_on: bool) -> void:
	owner.DiscordRichPresenceEnabled = toggled_on
	owner.Parent.SaveEverything()
