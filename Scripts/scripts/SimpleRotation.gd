extends TextureRect

@export var rotationAmount:float
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += rotationAmount * delta 
