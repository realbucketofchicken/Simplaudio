extends Control

var title:String
var artist:String
var directory:String
@onready var Name: RichTextLabel = $HSplitContainer/VBoxContainer/Name
@onready var Artist: Label = $HSplitContainer/VBoxContainer/Artist
@onready var play_button: Button = $PlayButton

signal PressedPlay(dir:String)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Name.text = title
	Artist.text = artist
	play_button.pressed.connect(Pressed)

func Pressed():
	print("Pressed on song: " + title)
	PressedPlay.emit(directory)
