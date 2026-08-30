extends Button

@onready var search_bar: LineEdit = $"../SearchBar"
@onready var songs_menu: Button = $"../SongsMenu"

@export var PressedIcon:Texture2D
@export var NotPressedIcon:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	search_bar.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		search_bar.clear()
		search_bar.show()
		songs_menu.hide()
		icon = PressedIcon
	else:
		search_bar.hide()
		songs_menu.show()
		icon = NotPressedIcon
