class_name FolderDisplay
extends Control

@onready var nameLabel: RichTextLabel = $HSplitContainer/VBoxContainer/Name
@onready var directory: Label = $HSplitContainer/VBoxContainer/Directory

@onready var options_dropdown: MenuButton = $HSplitContainer/HBoxContainer/OptionsDropdown

signal RemovePressed
signal MakePlaylistPressed

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	options_dropdown.get_popup().id_pressed.connect(OptionPressed)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func OptionPressed(id:int):
	match id:
		1:
			RemovePressed.emit(self)
		2:
			MakePlaylistPressed.emit()
