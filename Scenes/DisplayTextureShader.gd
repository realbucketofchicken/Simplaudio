@tool
extends TextureRect



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var shadMat:ShaderMaterial = material
	var offset:Vector2 = shadMat.get_shader_parameter("noiseOffset")
	delta = delta/10
	shadMat.set_shader_parameter("noiseOffset",Vector2(offset.x+delta,offset.y + (delta/3)))
