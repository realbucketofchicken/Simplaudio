extends Node

@export var dataHandler:DataHandler

var thread:Thread
var threading:bool
var RedoQueued:bool
var startTime:float
@export var LoadingMetadataWindow:Control
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thread = Thread.new()
	dataHandler.FoldersChanged.connect(StartLoad)

func StartLoad():
	if !threading:
		thread.start(LoadMetadata)
		threading = true
		startTime = Time.get_unix_time_from_system()
	else:
		RedoQueued = true

func LoadMetadata():
	for song in dataHandler.Songs:
		#metadataLabel.text = "Loading: " + song.Name
		var bytes:PackedByteArray = FileAccess.get_file_as_bytes(song.Location)
		var stream:AudioStreamMP3 = AudioStreamMP3.new()
		stream.data = bytes
		var metadata = MusicMetadataAutoload.get_mp3_metadata(stream)
		song.Album = metadata.album
		song.Author = metadata.artist
		song.MetadataLoaded = true
		#print(metadata.album)

func _process(_delta: float) -> void:
	LoadingMetadataWindow.visible = threading
	if threading:
		if !thread.is_alive():
			thread.wait_to_finish()
			threading = false
			var endTime = Time.get_unix_time_from_system()
			print("Took " + str(roundf(endTime - startTime)) + " seconds to read the metadata of " + str(dataHandler.Songs.size()) + " Songs!")
			if RedoQueued:
				StartLoad()
				RedoQueued = false
