extends Node

@export var loadButton:Button
@export var dataHandler:DataHandler
@export var metadataLabel:RichTextLabel

var thread:Thread
var threading:bool
var startTime:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	thread = Thread.new()
	loadButton.pressed.connect(StartLoad)

func StartLoad():
	thread.start(LoadMetadata)
	threading = true
	loadButton.disabled = true
	metadataLabel.text = "Loading..."
	startTime = Time.get_unix_time_from_system()

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
		print(metadata.album)

func _process(_delta: float) -> void:
	if threading:
		if !thread.is_alive():
			thread.wait_to_finish()
			threading = false
			loadButton.disabled = false
			var endTime = Time.get_unix_time_from_system()
			metadataLabel.text = "Took " + str(roundf(endTime - startTime)) + " seconds to read the metadata of " + str(dataHandler.Songs.size()) + " Songs!"
