class_name PlaylistInfo
extends Resource

@export var ListName:String
@export_enum("Stream","Folder","User") var ListType
@export var ListURL:String
@export var ListFolder:String
@export var ListSongs:Array[SongInfo]
