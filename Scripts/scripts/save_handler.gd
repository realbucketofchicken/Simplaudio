extends Node

var SavePath:String = "user://save.res"

@export var dataHandler:DataHandler
@export var addFolderLogic:AddFolderLogic

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	addFolderLogic.FoldersChanged.connect(saveSave)
	loadSave()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func saveSave():
	var save:Save = Save.new()
	save.Folders = dataHandler.Folders
	ResourceSaver.save(save,SavePath)


func loadSave():
	if FileAccess.file_exists(SavePath):
		var save:Save = ResourceLoader.load(SavePath)
		for folder in save.Folders:
			addFolderLogic.AddFolder(folder)

func saveMetadata():
	pass
