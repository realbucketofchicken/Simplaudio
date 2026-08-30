extends Button

@onready var search_results: SearchResults = $"../SearchResults"
@onready var parent:MainScene = owner
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	if search_results.SongsAmount != parent.textSongs.size():
		search_results.clear()
		for song in parent.textSongs:
			var nam = song
			search_results.add_item(nam)
	search_results.show()
