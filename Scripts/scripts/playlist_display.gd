extends Control

var PlaylistResource:PlaylistInfo

@export var Icons:Array[Texture]
@onready var icon: TextureRect = $HSplitContainer/Icon
@onready var listName: RichTextLabel = $HSplitContainer/VBoxContainer/Name

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	icon.texture = Icons[PlaylistResource.ListType]
	listName.text = PlaylistResource.ListName
