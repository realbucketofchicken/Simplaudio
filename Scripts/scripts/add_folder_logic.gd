extends Node

@export var Dialog:FileDialog
@export var dataHandler:DataHandler
@export var AddFolderButton:Button
@export var FolderParentNode:VBoxContainer
@export var folderDisplay:PackedScene
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialog.dir_selected.connect(Selected)
	AddFolderButton.pressed.connect(Dialog.show)


func Selected(path:String):
	print("file selected: ",path)
	AddFolder(path)

func AddFolder(path:String):
	dataHandler.AddPath(path)
	var display:FolderDisplay = folderDisplay.instantiate()
	FolderParentNode.add_child(display)
	display.directory.text = path
	display.nameLabel.text = "Folder"

func RemoveFolder():
	#TODO
	pass
