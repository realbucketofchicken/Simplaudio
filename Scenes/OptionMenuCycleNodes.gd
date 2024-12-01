extends OptionButton

@export var Nodes:Array[Control]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for idx in Nodes.size():
		#print(Nodes[idx])
		var isvisible = ((idx+1) == (get_selected_id()))
		#print(idx,"  ", isvisible)
		Nodes[idx].visible = isvisible
	#print("")
