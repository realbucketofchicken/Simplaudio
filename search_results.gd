class_name SearchResults
extends Control

signal index_pressed
signal song_deleted

const SEARCH_ITEM = preload("res://search_item.tscn")

@onready var item_container: VBoxContainer = $Control/ItemContainer

var SongsAmount:int

@onready var parent:MainScene = owner

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func add_item(text:String):
	var child = SEARCH_ITEM.instantiate()
	child.SongName = text.replace(".mp3", "")
	child.songidx = parent.textSongs.find(text)
	SongsAmount+=1
	child.PlayPressed.connect(songSelected)
	child.DeletePressed.connect(deletePressed)
	item_container.add_child(child)

func clear():
	SongsAmount = 0
	for child in item_container.get_children():
		child.queue_free()

func songSelected(idx:int):
	index_pressed.emit(idx)

func _input(event):
	if (event is InputEventMouseButton) and event.pressed:
		var evLocal = make_input_local(event)
		if !Rect2(Vector2(0,0),Vector2(size.x,size.y)).has_point(evLocal.position):
			hide()

func deletePressed(idx:int):
	song_deleted.emit(idx)
