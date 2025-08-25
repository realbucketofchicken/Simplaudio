extends Control

var SongName:String
var CurrentlyPlaying:bool
var songidx:int
@onready var songname: Button = $HBoxContainer/Songname
@onready var dropdown: Button = $HBoxContainer/Dropdown
@onready var popup_menu: PopupMenu = $PopupMenu


signal PlayPressed
signal DeletePressed
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	songname.text = SongName
	popup_menu.index_pressed.connect(popupPressed)

func popupPressed(idx:int):
	match idx:
		0:
			DeletePressed.emit(songidx)
		1:
			var songdir = MainScene.instance.CurrentDir + "/" + MainScene.instance.textSongs[songidx]
			var song = AudioStreamMP3.load_from_file(songdir)
			var meta:MusicMeta.MusicMetadata =  MusicMeta.new().get_mp3_metadata(song)
			print(songdir)
			meta.print_info()
			if meta.comments:
				OS.shell_open(meta.comments)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	dropdown.visible = songname.is_hovered() or dropdown.is_hovered()


func _on_songname_pressed() -> void:
	PlayPressed.emit(songidx)


func _on_dropdown_pressed() -> void:
	popup_menu.show()
	popup_menu.position = get_global_mouse_position()
