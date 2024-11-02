extends Control

var SongName:String
var CurrentlyPlaying:bool
var idx:int
@onready var songname: Button = $HBoxContainer/Songname
@onready var dropdown: Button = $HBoxContainer/Dropdown


signal PlayPressed
signal DeletePressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	songname.text = SongName


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dropdown.visible = songname.is_hovered() or dropdown.is_hovered()


func _on_songname_pressed() -> void:
	PlayPressed.emit(idx)


func _on_dropdown_pressed() -> void:
	pass
