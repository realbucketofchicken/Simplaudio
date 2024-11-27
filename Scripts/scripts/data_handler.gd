class_name DataHandler
extends Node

var audioPaths:PackedStringArray
var Songs:Dictionary

func AddPath(path:String):
	if not path in audioPaths:
		audioPaths.append(path)

func ready():
	pass
