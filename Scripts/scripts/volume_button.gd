extends Node

@export var volumeButton:Button
@export var volumeSlider:VSlider

@export var audioPlayerController:AudioPlayerController

@export var extendedLength:int = 200
@export var PositionCurve:Curve
var openProgress:float
@export var time:float = 0.5
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volumeSlider.value_changed.connect(VolumeChanged)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	openProgress = move_toward(openProgress, 0 if volumeButton.button_pressed else 1,delta / time)
	openProgress = clampf(openProgress,0,1)
	var actualVal:float = PositionCurve.sample_baked(openProgress) * extendedLength
	volumeSlider.size.y = actualVal
	volumeSlider.position.y = -actualVal
	volumeSlider.self_modulate.a = actualVal/extendedLength

func VolumeChanged(newVolume:float):
	print("new volume:",newVolume)
	audioPlayerController.SetVolume(newVolume)
