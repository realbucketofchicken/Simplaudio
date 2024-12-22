class_name AddFolderLogic
extends Node

@export var Dialog:FileDialog
@export var dataHandler:DataHandler
@export var AddFolderButton:Button
@export var FolderParentNode:VBoxContainer
@export var folderDisplay:PackedScene
@export var playerCon:AudioPlayerController
signal FoldersChanged
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialog.dir_selected.connect(Selected)
	AddFolderButton.pressed.connect(Dialog.show)


func Selected(path:String):
	print("file selected: ",path)
	if !dataHandler.Folders.has(path):
		AddFolder(path)

func AddFolder(path:String):
	dataHandler.AddPath(path)
	var display:FolderDisplay = folderDisplay.instantiate()
	FolderParentNode.add_child(display)
	display.directory.text = path
	display.nameLabel.text = path.split("/")[-1]
	display.RemovePressed.connect(RemoveFolder)
	FoldersChanged.emit()

func RemoveFolder(Folder:FolderDisplay):
	dataHandler.Folders.erase(Folder.directory.text)
	print(dataHandler.Folders)
	print(Folder.directory.text)
	dataHandler.RemoveSongsFromFolder(Folder.directory.text)
	Folder.queue_free()
	FoldersChanged.emit()
