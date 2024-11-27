extends Node

@export var Left:bool
@export var AnimationSpeed:float = 0.5

@export var bar:Control
@export var button:Button
@export var buttonImage:TextureRect
@export var imgRotOffset:float
@export var PositionCurve:Curve

var barStartingPos:Vector2

var openProgress:float


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bar.show()
	barStartingPos = bar.position
	bar.position.x = (-1 if Left else 1) * (bar.size.x - button.size.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Logic for bar moving
	openProgress = move_toward(openProgress,(1 if button.button_pressed else 0),delta / AnimationSpeed)
	var hiddenPos:float = (-1 if Left else 1) * (bar.size.x - button.size.x)
	var visiblePos:float = barStartingPos.x
	bar.position.x = lerpf(hiddenPos,visiblePos,PositionCurve.sample_baked(openProgress))
	# Logic for icon rotation
	buttonImage.rotation = deg_to_rad(lerpf(0,180,PositionCurve.sample_baked(openProgress)) + imgRotOffset)
