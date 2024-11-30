class_name DataHandler
extends Node

var audioPaths:PackedStringArray
var Songs:Array[SongInfo]
@export var AudioPlayer:AudioPlayerController
var CurrentIdx:int

func AddPath(path:String):
	if not path in audioPaths:
		audioPaths.append(path)
		AddSongsFromFolder(path)

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
					Song.Name = file_name
					Song.Location = path + "/" + file_name
					Songs.append(Song)
			file_name = dir.get_next()
		#for song in Songs.size():
		#	print(Songs[song-1].Location)
		if Songs.size() >0:
			print("songs")
	else:
		print("An error occurred when trying to access the path.")
