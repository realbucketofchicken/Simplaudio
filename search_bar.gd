extends LineEdit
@onready var search_results: PopupMenu = $"../SearchResults"

var values:Dictionary = {}
var ErrorMargin:float = 0.9
var updatetime:float = 0.5
var currentTime:float 
var TextChanged:bool
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	search_results.popup_window = false
	search_results.unfocusable = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	currentTime -= delta
	if TextChanged:
		if currentTime < 0:
			release_focus()
			TextChanged = false
			search_results.clear(true)
			values.clear()
			currentTime = updatetime
			var _i:int = 0
			var _s:int = 0
			for song:String in owner.textSongs:
				var margin:float
				var fragments:Array
				#print(int((text.length() / 2.0) + 0.5))
				for num in range(int((text.length() / 2.0) + 0.5)):
					if text.to_lower().substr(int(num*2),2):
						fragments.append(text.to_lower().substr(int(num*2),2))
					elif text.to_lower().substr(int(num*2),1):
						fragments.append(text.to_lower().substr(int(num*2),1))
				var amountOfFrags:int
				for fragment:String in fragments:
					
					if song.to_lower().containsn(fragment):
						amountOfFrags +=1
				
				margin = float(amountOfFrags) / fragments.size()
				if margin > ErrorMargin:
					search_results.add_item(song.replace(".mp3","") )
					values[_i] = _s
					_i += 1
				_s += 1

func _on_search_results_index_pressed(index: int) -> void:
	print("index " + str(index))
	owner.SetSong(values[index])
	

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0),Vector2(search_results.size.y+ size.y,size.x)).has_point(evLocal.position):
			search_results.hide()

func _on_text_submitted(new_text: String) -> void:
	TextChanged = true
	if !search_results.visible:
		search_results.show()
