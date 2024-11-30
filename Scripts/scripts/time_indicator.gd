extends Node

@export var audioPlayerController:AudioPlayerController
@export var currentTimeLabel:Label
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var string:String = GlobalFuncs.SecondsToIndicator(audioPlayerController.GetCurrentSongProgress()) + " / " + GlobalFuncs.SecondsToIndicator(audioPlayerController.GetSongLength())
	currentTimeLabel.text = string
