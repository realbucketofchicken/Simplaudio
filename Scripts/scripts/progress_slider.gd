extends Node

@export var audioPlayerController:AudioPlayerController
@export var ProgressSlider:Slider

var adjusting:bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ProgressSlider.drag_ended.connect(DragStop)
	ProgressSlider.drag_started.connect(DragStart)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !adjusting:
		ProgressSlider.value = audioPlayerController.GetCurrentProgressZeroOne()

func DragStart():
	adjusting = true

func DragStop(changed:bool):
	adjusting = false
	if changed:
		audioPlayerController.SetSongPos(ProgressSlider.value)
