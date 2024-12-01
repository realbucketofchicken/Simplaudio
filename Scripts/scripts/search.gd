class_name Search
extends Node

@export var dataHandler:DataHandler

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func search(forwhat:String) -> Array[SongInfo]:
	var results:Array[SongInfo]
	for song in dataHandler.Songs:
		if song.Name.containsn(forwhat) or song.Author.containsn(forwhat) or song.Album.containsn(forwhat):
			results.append(song)
	return results
