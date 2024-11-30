extends Node

@export var backbutton:Button
@export var frontbutton:Button
@export var playManger:PlayManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	frontbutton.pressed.connect(playManger.playSongRelative)
	backbutton.pressed.connect(playBack)

func playBack():
	playManger.playSongRelative(-1)
