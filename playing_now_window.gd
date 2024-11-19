extends Control

@export var ParentScene:MainScene
@onready var desctibtor: Label = $Desctibtor
@onready var ParentWindow:Window = $".."
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ParentScene.SongChanged.connect(SongChanged)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ParentWindow.size = size 

func SongChanged():
	print("SongChanged: ", ParentScene.currentSongName)
	desctibtor.text = 'Now Playing: "'  + ParentScene.currentSongName + '"'
	if ParentScene.currentArtistName:
		desctibtor.text += " from " + ParentScene.currentArtistName
	#ParentWindow.size = size * 2
