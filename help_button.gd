extends Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _pressed() -> void:
	OS.shell_open("https://github.com/yt-dlp/yt-dlp/blob/master/supportedsites.md")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
