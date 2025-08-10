extends ColorRect
@onready var StandardColor = color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if get_parent().is_hovered():
		color = StandardColor.lightened(0.3)
	else:
		color = StandardColor
