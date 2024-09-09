extends Button
@onready var volume_slider: VSlider = $"../VolumeSlider"
var BaseOffsetPX:int = 4
var Target:float = 200
var currentlyExtending:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	volume_slider.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentlyExtending:
		volume_slider.size.y = lerp(volume_slider.size.y,Target,0.25)
	else:
		volume_slider.size.y -=3
		volume_slider.size.y = lerp(Target,volume_slider.size.y,1.25)
	volume_slider.position.y = (BaseOffsetPX- 90) - volume_slider.size.y + (owner.size.y)
	volume_slider.self_modulate.a = volume_slider.size.y / 200
	if volume_slider.size.y > 15:
		volume_slider.show()
	else:
		volume_slider.hide()



func _on_toggled(toggled_on: bool) -> void:
	if toggled_on:
		volume_slider.show()
		currentlyExtending = true
	else:
		currentlyExtending = false
		volume_slider.size.y = 192
