extends Node

@export var dataHandler:DataHandler
@export var CreatePlaylistButton:Button
@export var CreatePlaylistMenu:Control

@export var PlaylistNameEdit:LineEdit
@export var PlaylistTypeDropdown:OptionButton
@export var CreateButton:Button

@export var PlaylistTypeSelector:OptionButton
@export var CloudURLInput:LineEdit
@export var FolderOptionDropdown:OptionButton
@export var NoFoldersNotice:Label




# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	CreatePlaylistButton.pressed.connect(showCreatePlaylist)
	CreateButton.pressed.connect(CreatePlaylist)

func _process(_delta: float) -> void:
	match PlaylistTypeSelector.get_selected_id():
		1:
			CreateButton.disabled = bool(CloudURLInput.text == "")
		
		2:
			CreateButton.disabled = bool(FolderOptionDropdown.get_selected_id() == -1)
			NoFoldersNotice.visible = bool(FolderOptionDropdown.item_count == 0)
		
		3:
			CreateButton.disabled = false
	if PlaylistNameEdit.text == "":
		CreateButton.disabled = true
	

func showCreatePlaylist():
	CreatePlaylistMenu.show()
	PlaylistNameEdit.clear()
	PlaylistTypeDropdown.select(0)

func CreatePlaylist():
	pass
