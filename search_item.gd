extends Control

var SongName:String
var CurrentlyPlaying:bool
var idx:int
@onready var songname: Button = $HBoxContainer/Songname

signal PlayPressed
signal DeletePressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	songname.text = SongName


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_songname_pressed() -> void:
	PlayPressed.emit(idx)
