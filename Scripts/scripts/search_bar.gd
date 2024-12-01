extends Node


@export var searchBar:LineEdit
@export var searchButton:Button
@export var resultsParent:Control
@export var resultsStacker:VBoxContainer
@export var search:Search
@export var playManager:PlayManager
@export var dataHandler:DataHandler

const SONG_DISPLAY = preload("res://Scenes/SongDisplay.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	searchBar.text_submitted.connect(searchSongs)
	searchButton.pressed.connect(searchSongs)

func searchSongs(text:String=""):
	resultsParent.show()
	if searchBar.text:
		var results:Array[SongInfo] = search.search(searchBar.text)
		for child in resultsStacker.get_children():
			child.queue_free()
		for song in results:
			var songDisplay = SONG_DISPLAY.instantiate()
			songDisplay.artist = song.Author
			songDisplay.title = song.Name
			songDisplay.directory = song.Location
			resultsStacker.add_child(songDisplay)
			songDisplay.PressedPlay.connect(ReqSongPlay)
	else:
		for child in resultsStacker.get_children():
			child.queue_free()
		for song in dataHandler.Songs:
			var songDisplay = SONG_DISPLAY.instantiate()
			songDisplay.artist = song.Author
			songDisplay.title = song.Name
			songDisplay.directory = song.Location
			resultsStacker.add_child(songDisplay)
			songDisplay.PressedPlay.connect(ReqSongPlay)

func ReqSongPlay(Dir:String):
	playManager.playSongByDirectory(Dir)
