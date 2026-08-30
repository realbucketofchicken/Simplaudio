extends Node2D
@export var Daytime:Control#1
@export var Evening:Control#2
@export var Nighttime:Control#3
var currentBG:int

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var timeInHours = Time.get_datetime_dict_from_system()["hour"]
	if timeInHours < 6:
		currentBG = 3
	elif timeInHours >= 6 and timeInHours <= 9:
		currentBG = 2
	elif timeInHours >= 9 and timeInHours <= 17:
		currentBG = 1
	elif timeInHours >= 17 and timeInHours <= 21:
		currentBG = 2
	elif timeInHours > 21:
		currentBG = 3
	if currentBG == 1:
		Daytime.show()
		Nighttime.hide()
		Evening.hide()
	elif currentBG == 2:
		Daytime.hide()
		Nighttime.hide()
		Evening.show()
	elif currentBG == 3:
		Daytime.hide()
		Nighttime.show()
		Evening.hide()
