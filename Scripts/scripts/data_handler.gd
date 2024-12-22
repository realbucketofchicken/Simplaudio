class_name DataHandler
extends Node

var Folders:Array[String]
var Playlists:Array[PlaylistInfo]
var Songs:Array[SongInfo]

@export var AudioPlayer:AudioPlayerController
var CurrentIdx:int
var randomized:bool
signal NewSongsAdded
signal FolderAdded
signal FolderRemoved
signal FoldersChanged

func AddPath(path:String):
	if not path in Folders:
		Folders.append(path)
		AddSongsFromFolder(path)
		FolderAdded.emit()
		FoldersChanged.emit()

func AddSongsFromFolder(path:String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if file_name.ends_with(".mp3"):
				if !dir.current_is_dir():
					#print("Found file: " + file_name)
					var Song:SongInfo = SongInfo.new()
					Song.Name = file_name.replace(".mp3","")
					Song.Location = path + "/" + file_name
					Songs.append(Song)
			file_name = dir.get_next()
		#for song in Songs.size():
		#	print(Songs[song-1].Location)
		if Songs.size() >0:
			print("songs")
			NewSongsAdded.emit()
	else:
		printerr("An error occurred when trying to access the path.")

func RemoveSongsFromFolder(path:String):
	Songs.clear()
	FolderRemoved.emit()
	FoldersChanged.emit()
	for folder in Folders:
		AddSongsFromFolder(folder)
