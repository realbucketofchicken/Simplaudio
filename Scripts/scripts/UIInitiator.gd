extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children(true):
		if child is Button:
			child.focus_mode = Control.FOCUS_NONE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
