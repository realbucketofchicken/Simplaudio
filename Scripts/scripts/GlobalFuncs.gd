extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func SecondsToIndicator(input:int) -> String:
	var seconds = input % 60
	var minutes:int = (input /60) % 60
	var hours:int = minutes /60
	var days:int = hours /24
	var dayStr = (str(days) + ":" if days else "")
	var hourStr = (str(hours) + ":" if hours else "")
	var minuteStr = (str(minutes) if minutes else "0") + ":"
	var secondStr = (str(seconds) if seconds else "00")
	var endString:String = dayStr + hourStr + minuteStr + secondStr
	return endString
