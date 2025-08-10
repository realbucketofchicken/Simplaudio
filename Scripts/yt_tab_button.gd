extends Button

@onready var youtube_menu_holder: Control = $"../YoutubeMenuHolder"
@onready var youtube_menu: Control = $"../YoutubeMenuHolder/Youtube menu"
@onready var yt_link: LineEdit = $"../YoutubeMenuHolder/Youtube menu/YTLink"
@onready var yt_download: Button = $"../YoutubeMenuHolder/Youtube menu/YTDownload"
@onready var loading_img: Sprite2D = $"../YoutubeMenuHolder/Youtube menu/LoadingIMG"

var currentlyExtending:bool
var Target:float = 50
var downloadList:bool = false
signal ContinueProcess

@onready var Parent:MainScene = get_tree().root.get_child(3)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	YtDlp.setup_completed.connect(YTSetupCompleted)
	yt_download.pressed.connect(DownloadYTVidFromLink)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentlyExtending:
		youtube_menu.position.x = clamp(lerp(youtube_menu.position.x,Target,0.25),0,100)
	else:
		youtube_menu.position.x -=1
		youtube_menu.position.x = clamp(lerp(Target,youtube_menu.position.x,1.25),0,100)
	youtube_menu.modulate.a = youtube_menu.position.x / Target
	if youtube_menu.position.x > 1:
		youtube_menu.show()
	else:
		youtube_menu.hide()

func YTSetupCompleted():
	if owner.ShowInstallAlerts:
		OS.alert("Youtube setup completed, from now on its safe to close the app","youtube setup")
	loading_img.hide()
	yt_download.disabled = false

func DownloadPlaylistConf():
	downloadList = true
	ContinueProcess.emit()

func DownloadSingleSongConf():
	ContinueProcess.emit()

func DownloadYTVidFromLink():
	if yt_link.text.is_empty():
		OS.alert("please gimme a link")
		return
	if "list=" in yt_link.text:
		Parent.playlist_or_song.show()
		Parent.playlist_or_song.confirmed.connect(DownloadPlaylistConf)
		Parent.playlist_or_song.canceled.connect(DownloadSingleSongConf)
		await ContinueProcess
		print(yt_link.text)
	var download:YtDlp.Download = YtDlp.download(yt_link.text)
	if download == null:
		OS.alert("youtube setup has not finished, please wait for the finish notification")
		return
	loading_img.show()
	yt_link.clear()
	download.set_destination(owner.PlaylistsLocation[owner.CurrentPlaylist])
	print(owner.PlaylistsLocation[owner.CurrentPlaylist])
	download.convert_to_audio(YtDlp.Audio.MP3) 
	download._download_playlist = downloadList
	download.start()
	yt_download.disabled = true
	download.completely_finished.connect(DownloadCompleted)

func DownloadCompleted():
	yt_download.disabled = false
	owner.GetSongs(owner.PlaylistsLocation[owner.CurrentPlaylist])
	loading_img.hide()


func _on_toggled(toggled_on: bool) -> void:
	if !YtDlp.is_setup():
		yt_download.disabled = true
		if YtDlp.FilesMissing():
			print("Need to install")
			owner.ShowInstallAlerts = true
			OS.alert("ONE TIME SETUP, PLEASE DONT CLOSE THE MUSIC PLAYER","yt-dl and ffmpeg setup")
		YtDlp.setup()
		loading_img.show()
	if toggled_on:
		currentlyExtending = true
		youtube_menu.position.x = 1
	else:
		currentlyExtending = false
