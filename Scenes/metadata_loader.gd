extends Node

@export var loadButton:Button
@export var dataHandler:DataHandler
@export var metadataLabel:RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	loadButton.pressed.connect(LoadMetadata)

func LoadMetadata():
	var startTime = Time.get_unix_time_from_system()
	loadButton.disabled = true
	for song in dataHandler.Songs:
		metadataLabel.text = "Loading: " + song.Name
		var bytes:PackedByteArray = FileAccess.get_file_as_bytes(song.Location)
		var stream:AudioStreamMP3 = AudioStreamMP3.new()
		stream.data = bytes
		var metadata = MusicMetadataAutoload.get_mp3_metadata(stream)
		song.Album = metadata.album
		song.Author = metadata.artist
		print(metadata.album)
		await get_tree().create_timer(0.003).timeout
	loadButton.disabled = false
	var endTime = Time.get_unix_time_from_system()
	metadataLabel.text = "Took " + str(roundf(endTime - startTime)) + " seconds to read the metadata of " + str(dataHandler.Songs.size()) + " Songs!"
