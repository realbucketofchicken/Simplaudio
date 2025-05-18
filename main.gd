class_name MainScene
extends Control
@onready var file_dialog: FileDialog = $FileDialog
@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var randomize_list: Button = $RandomizeList
@onready var play_list: Button = $playList
@onready var current_progress: HSlider = $CurrentProgress
@onready var volume_slider: VSlider = $VolumeSlider
@onready var skip: Button = $Skip
@onready var go_back: Button = $GoBack
@onready var song_name: Label = $SongName
@onready var loop: Button = $Loop
@onready var time_listening_song: Label = $TimeListeningSong
@onready var cover: Cover = $CoverHolder/Cover
@onready var wav_disclaimer: AcceptDialog = $WavDisclaimer
@onready var youtube_menu_holder: Control = $YoutubeMenuHolder
@onready var youtube_menu: Control = $"YoutubeMenuHolder/Youtube menu"
@onready var yt_link: LineEdit = $"YoutubeMenuHolder/Youtube menu/YTLink"
@onready var yt_download: Button = $"YoutubeMenuHolder/Youtube menu/YTDownload"
@onready var loading_img: Sprite2D = $"YoutubeMenuHolder/Youtube menu/LoadingIMG"
@onready var songs_menu: Button = $SongsMenu
@onready var version: Label = $Version
@onready var paused_indicator: TextureRect = $PausedIndicator
@onready var settings_menu_child: Settings = $SettingsHolder/SettingsPopup/SettingsMenuChild
@onready var artist_name: Label = $ArtistName
@onready var user_bg: TextureRect = $UserBG
@onready var playlists_holder: VBoxContainer = $PlaylistPanelHolder/PlaylistsPanel/PlaylistsContainer/VBoxContainer/PlaylistsHolder
@onready var play_all: Button = $PlaylistPanelHolder/PlaylistsPanel/PlaylistsContainer/VBoxContainer/HBoxContainer/PlayAll
@onready var album_name: Label = $Album
@onready var playlist_or_song: ConfirmationDialog = $PlaylistOrSong
@onready var search_results: SearchResults = $SearchResults
@onready var delete_confirm: ConfirmationDialog = $deleteConfirm
@onready var search_bar: LineEdit = $SearchBar
@onready var playing_now: Window = $PlayingNow

var DiscordUsername:String

const PLAYLIST_DISPLAY = preload("res://PlaylistDisplay.tscn")
const PAUSE = preload("res://Pause.png")
const PLAY = preload("res://Play.png")

var OpenedSong:String = ""
var CurrentIDX:int
var CurrentSongLenth:float
var CurrentDir:String
var textSongs:Array
var Randomized:bool
var LoopingSong:bool
var Paused:bool
var UpdateProgressSlider:bool = true
var ShowInstallAlerts:bool = false
var ReactivateLoop:bool
var SeenWAVDisclaimer:bool
var TimeSpentListening:float
var DiscordRichPresenceEnabled:bool = false
var SplashStrings:Array
var SaveInterval:float = 11.2
var currentSaveTime:float = 0.4
var CurrentPausedIndicatorShaderIntensity:float
var CurrentCustomBackroundImageDirectory:String
var Playlists:Dictionary = {}
var PlaylistsLocation:Dictionary
var BackroundSetup:bool
var CurrentPlaylist:String
var PlayAllLists:bool
var UsingPlayingNow:bool

@export var LoopPressed:Texture2D
@export var LoopNotPressed:Texture2D

signal ContinueDelete
var deleteSong:bool

signal SongChanged
var currentSongName:String
var currentArtistName:String
var currentAlbumName:String

var LoadingSaveFailed:bool = true
@onready var loading_failed_screen: Control = $LoadingFailedScreen

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	playing_now.visible = false
	get_tree().root.min_size = Vector2(850,492)
	current_progress.drag_ended.connect(SongDragStopped)
	current_progress.drag_started.connect(SongDragStarted)
	loop.pressed.connect(LoopSong)
	file_dialog.dir_selected.connect(DirectorySelected)
	randomize_list.pressed.connect(Randomize)
	play_list.pressed.connect(PlaySongs)
	volume_slider.value_changed.connect(SetVolume)
	skip.pressed.connect(Skip)
	go_back.pressed.connect(GoBack)
	search_results.index_pressed.connect(SetSong)
	search_results.song_deleted.connect(deletesong)
	var Strin:String
	for Arg in OS.get_cmdline_args():
		if Arg.to_lower().ends_with(".mp3") or Arg.to_lower().ends_with(".wav"):
			OS.alert("opening files like this\nis no longer supported")
	var data:Dictionary
	var save = loadUserdata()
	if save != {}:
		data = save
	loadPlaylists()
	if Strin.is_empty():
		if !Playlists.is_empty():
			PlaylistSelected(Playlists.keys()[0],PlaylistsLocation[Playlists.keys()[0]])
			#CurrentPlaylist = Playlists.keys()[0]
			#CurrentDir = PlaylistsLocation[Playlists.keys()[0]]
		for Playlist in Playlists.keys():
			var child = PLAYLIST_DISPLAY.instantiate(PackedScene.GEN_EDIT_STATE_DISABLED)
			if PlaylistsLocation.has(Playlist):
				if PlaylistsLocation[Playlist] is String:
					child.PlaylistLocation = PlaylistsLocation[Playlist]
				else:
					print("PLAYLIST LOCATION: " + str(PlaylistsLocation[Playlist]))
			child.PlaylistName = Playlist
			if Playlists.has(Playlist):
				if Playlists[Playlist] is String:
					child.PlaylistSongs = Playlists[Playlist]
			playlists_holder.add_child(child)
		if data != null:
			if data.has("Volume"):
				print(data["Volume"])
				SetVolume(data["Volume"])
			if data.has("CurrIDX"):
				CurrentIDX = int(data["CurrIDX"]) % textSongs.size() if textSongs.size() !=0 and int(data["CurrIDX"]) != 0 else 0
			if data.has("Randomized"):
				Randomize()
			if data.has("Playing"):
				PlaySongs()
			if data.has("SeenWAVDisclaimer"):
				SeenWAVDisclaimer = data["SeenWAVDisclaimer"]
			if data.has("TimeSpentListening"):
				TimeSpentListening = data["TimeSpentListening"]
				print("Listening time: " + str(TimeSpentListening))
			if data.has("DiscordRichPresenceEnabled"):
				settings_menu_child.discord_rich_presence_button.set_pressed_no_signal(data["DiscordRichPresenceEnabled"])
				DiscordRichPresenceEnabled = data["DiscordRichPresenceEnabled"]
				if data["DiscordRichPresenceEnabled"]:
					setUpDiscord()
			if data.has("DiscordUsername"):
				if data["DiscordUsername"]:
					if DiscordRichPresenceEnabled:
						DiscordUsername = data["DiscordUsername"]
						print("stiff ",data)
			if data.has("ReverbEnabled") :
				settings_menu_child.reverb_check.button_pressed = data["ReverbEnabled"]
			if data.has("ReverbRoomSize") :
				settings_menu_child.room_size_slider.value = data["ReverbRoomSize"]
			if data.has("ReverbDampening") :
				settings_menu_child.dampening_size_slider.value = data["ReverbDampening"]
			if data.has("ReverbSpread") :
				settings_menu_child.spread_size_slider.value = data["ReverbSpread"]
			if data.has("CompressionEnabled") :
				settings_menu_child.compression_check.button_pressed = data["CompressionEnabled"]
			if data.has("CompressionThreshold") :
				settings_menu_child.threshold_slider.value = data["CompressionThreshold"]
			if data.has("CompressionRatio") :
				settings_menu_child.ratio_slider.value = data["CompressionRatio"]
			if data.has("CompressionGain") :
				settings_menu_child.gain_slider.value = data["CompressionGain"]
			if data.has("CurrentCustomBackroundImageDirectory"):
				CurrentCustomBackroundImageDirectory = data["CurrentCustomBackroundImageDirectory"]
				print("CurrentCustomBackroundImageDirectory " + CurrentCustomBackroundImageDirectory)
			if data.has("PlayAllLists"):
				PlayAllLists = data["PlayAllLists"]
				if PlayAllLists:
					play_all.button_pressed = true
			if data.has("UsingPlayingNow"):
				UsingPlayingNow = data["UsingPlayingNow"]
	else:
		if data != null:
			print(data["Volume"])
			SetVolume(data["Volume"])
		var TrueDir
		var TheSongName = Strin
		var lenght = Strin.length()
		var AmoutOfSwag:int = 0
		for skibidi in lenght:
			if Strin.ends_with("\\"):
				AmoutOfSwag += 1
				if AmoutOfSwag ==2:
					TheSongName = TheSongName.erase(0,lenght)
					print(TheSongName)
					break
			else:
				lenght -= 1
				Strin = Strin.erase(lenght)
		OpenedSong = TheSongName
		DirectorySelected(Strin)
		PlaySongs()
		#PlaySongs()
	
	for child in get_children(true):
		if child is Control:
			child.focus_mode = child is LineEdit
	if LoadingSaveFailed:
		var file2 = FileAccess.open("user://playlists.dat", FileAccess.READ)
		if (file2.get_error() != ERR_FILE_NOT_FOUND) or (file2.get_error() != ERR_FILE_BAD_PATH):
			loading_failed_screen.Show()
			ERR_PRINTER_ON_FIRE

func setUpDiscord():
	DiscordRPC.app_id = 1276916292170809426
	DiscordRPC.refresh()
	print("stiff chicks  ",DiscordRPC.get_current_user())
	SplashStrings = ["the party just started!"]
	var LText = SplashStrings.pick_random()
	print(LText)
	DiscordRPC.large_image_text = LText
	if DiscordUsername == "vrenthusiest":
		if randi_range(1,4) == 1:
			DiscordRPC.large_image = "nullbody"
			DiscordRPC.large_image_text = "I am racist against nullbodys - Vr"
		else:
			DiscordRPC.large_image = "logo"
	else:
		DiscordRPC.large_image = "logo"
	DiscordUsername = DiscordRPC.get_current_user().get("username")
	DiscordRPC.refresh()
	# this is boolean if everything worked
	print("Discord working: " + str(DiscordRPC.get_is_discord_working()))
	# Set the first custom text row of the activity here
	if textSongs.size() >= CurrentIDX:
		if textSongs.size() > CurrentIDX:
			DiscordRPC.details = textSongs[CurrentIDX]
	# Set the second custom text row of the activity here
	DiscordRPC.state = ""
	# Image key for small image from "Art Assets" from the Discord Developer website
	# Tooltip text for the large image
	# Image key for large image from "Art Assets" from the Discord Developer website
	DiscordRPC.small_image = ""
	# Tooltip text for the small image
	DiscordRPC.small_image_text = "Nothing"
	# "02:41 elapsed" timestamp for the activity
	# Always refresh after changing the values!
	DiscordRPC.refresh() 

func deletesong(idx:int):
	var currentDir:String= CurrentDir
	currentDir += "/" + textSongs[idx]
	delete_confirm.show()
	delete_confirm.dialog_text = "are you sure you want to delete \n" + textSongs[idx] +"?"
	delete_confirm.confirmed.connect(deleteConfirmed)
	delete_confirm.canceled.connect(deleteCancelled)
	await ContinueDelete
	delete_confirm.canceled.disconnect(deleteCancelled)
	delete_confirm.confirmed.disconnect(deleteConfirmed)
	if deleteSong:
		print("deleted + " + currentDir)
		deleteSong = false
		var dir = DirAccess.remove_absolute(currentDir)
		print("error code " +str(dir) + " (zero is good)")
		if dir == 0:
			textSongs.remove_at(idx)
		if search_bar.visible:
			search_bar.updateResults()
		else:
			songs_menu._pressed()
		Playlists[CurrentPlaylist].erase(textSongs[idx])

func deleteCancelled():
	deleteSong = false
	ContinueDelete.emit()

func deleteConfirmed():
	deleteSong = true
	ContinueDelete.emit()

func SongDragStopped(Changed:bool):
	if Changed:
		music_player.play(current_progress.value * CurrentSongLenth / current_progress.max_value)
		if Paused:
			pausePlay()
		
		UpdateProgressSlider = true
		DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system() - (current_progress.value * CurrentSongLenth / current_progress.max_value))
		DiscordRPC.refresh()

func SongDragStarted():
	UpdateProgressSlider = false


func LoopSong():
	if LoopingSong == true:
		LoopingSong = false
		loop.icon = LoopNotPressed
	else:
		LoopingSong = true
		loop.icon = LoopPressed

func SetSong(IDX:int):
	if LoopingSong:
		LoopingSong = false
		ReactivateLoop = true
		loop.icon = LoopNotPressed
	CurrentIDX = IDX -1
	PlaySongs()
	music_player.stop()
	if !LoadingSaveFailed:
		SaveEverything()
	print("SetSong")

func pausePlay():
	if music_player.stream_paused == true:
		music_player.stream_paused = false
	else:
		music_player.stream_paused = true

func Skip():
	if LoopingSong:
		LoopingSong = false
		ReactivateLoop = true
	loop.icon = LoopNotPressed
	music_player.stop()

func GoBack():
	if LoopingSong:
		LoopingSong = false
		ReactivateLoop = true
	loop.icon = LoopNotPressed
	CurrentIDX -=2
	music_player.stop()

func SetVolume(Volume:float):
	
	var volume = (-50 + (Volume/2))
	if Volume >= 2:
		AudioServer.set_bus_volume_db(1,volume)
	else:
		AudioServer.set_bus_volume_db(1,-1000)
	volume_slider.value = Volume

func SelectPlaylistDir():
	file_dialog.show()
	if !LoadingSaveFailed:
		SaveEverything()
	print("Select Playtlist dir")

func DirectorySelected(dir:String):
	Randomized = false
	print(dir)
	CurrentDir = dir
	GetSongs(dir)

func PlaySongs():
	
	if music_player.playing:
		Paused = true
		music_player.stream_paused = true
		play_list.icon = PLAY
		DiscordRPC.state = "Paused"
		print(DiscordRPC.get_current_user())
	else:
		DiscordRPC.start_timestamp = int(Time.get_unix_time_from_system() - (current_progress.value * CurrentSongLenth / current_progress.max_value))
		print(DiscordRPC.get_current_user())
		
		DiscordRPC.state = "Listening To Music"
		Paused = false
		music_player.stream_paused = false
		play_list.icon = PAUSE
	
	if music_player.get_playback_position() == 0.0:
		if LoopingSong:
			music_player.play()
		elif textSongs.size() != 0:
			var index:int
			if OpenedSong.is_empty():
				if PlayAllLists:
					if CurrentIDX >= (textSongs.size()):
						CurrentPlaylist = Playlists.keys()[(Playlists.keys().find(CurrentPlaylist)+1) % Playlists.keys().size()]
						print("ASSS")
						print(CurrentPlaylist)
				index = CurrentIDX % textSongs.size()
			else:
				if PlayAllLists:
					if CurrentIDX+1 >= (textSongs.size()-1):
						CurrentPlaylist = Playlists.keys()[(Playlists.keys().find(CurrentPlaylist)+1) % Playlists.keys().size()]
						print("AS")
				index = textSongs.find(OpenedSong) % textSongs.size()
			if PlayAllLists:
				if !CurrentDir.ends_with(CurrentPlaylist):
					GetSongs(PlaylistsLocation[CurrentPlaylist])
			var CurrentSongDir:String = PlaylistsLocation[CurrentPlaylist] + "/" + textSongs[index]
			DiscordRPC.details = textSongs[index].replace(".mp3","")
			currentSongName = textSongs[index].replace(".mp3","")
			print(CurrentSongDir)
			var sonnname:String = textSongs[index]
			sonnname = sonnname.replace(".mp3", "")
			song_name.text = sonnname
			var dat = FileAccess.get_file_as_bytes(CurrentSongDir)
			var song:AudioStreamMP3
			if CurrentSongDir.to_lower().ends_with(".mp3"):
				song = AudioStreamMP3.new()
				cover.ChangeCover(song)
			song.data = dat
			if CurrentSongDir.to_lower().ends_with(".mp3"):
				cover.ChangeCover(song)
				print(MusicMetadataAutoload.get_mp3_metadata(song).print_info())
				if MusicMetadataAutoload.get_mp3_metadata(song).title != "":
					song_name.text = MusicMetadataAutoload.get_mp3_metadata(song).title
				if MusicMetadataAutoload.get_mp3_metadata(song).artist != "":
					currentArtistName = MusicMetadataAutoload.get_mp3_metadata(song).artist
				else: currentArtistName = ""
				artist_name.text = currentArtistName
				if MusicMetadataAutoload.get_mp3_metadata(song).album != "":
					currentAlbumName = MusicMetadataAutoload.get_mp3_metadata(song).album
				else: currentAlbumName = ""
				album_name.text = currentAlbumName
			if song != null:
				CurrentSongLenth = song.get_length()
				music_player.stream = song
				music_player.play()
				if !LoadingSaveFailed:
					SaveEverything()
				print("set stream")
		SongChanged.emit()


func GetSongs(dir:String):
	print("Selected dir: " + dir)
	var Access = DirAccess.open(dir)
	if Access != null:
		CurrentDir = dir
		@warning_ignore("static_called_on_instance")
		var Read:Array = Access.get_files_at(dir)
		var songs:Array
		var WavDisclaimer:bool
		for song:String in Read:
			if song.contains(".mp3"):
				songs.append(song)
			elif song.contains(".wav"):
				WavDisclaimer = true
		
		if WavDisclaimer:
			if !SeenWAVDisclaimer:
				wav_disclaimer.show()
				SeenWAVDisclaimer = true
		#print(songs)
		search_results.clear()
		textSongs = songs
		for song in textSongs:
			var nam = song
			search_results.add_item(nam)

func Randomize():
	if textSongs.size() != 0:
		var Access = DirAccess.open(CurrentDir)
		var Read:Array = Access.get_files_at(CurrentDir)
		var Ssong:String
		for read:String in Read:
			if textSongs.size() > CurrentIDX:
				if read.contains(textSongs[CurrentIDX]):
					Ssong = read
					print("Ssong = " + str(read))
		textSongs.shuffle()
		if Ssong != null:
			CurrentIDX = textSongs.find(Ssong) # % textSongs.size()
			print(CurrentIDX)
		
		
		Randomized = true
		search_results.clear()
		for song in textSongs:
			var nam = song
			search_results.add_item(nam)
		#print(textSongs)

func PlaylistSelected(Playlist:String,PlaylistLocation:String):
	print(PlaylistLocation)
	if Playlists.get(Playlist) == null:
		printerr("PlaylistSelected(Playlist:String):: you FUCKED, no playlist found")
		return
	else:
		CurrentPlaylist = Playlist
		PlaylistsLocation[Playlist] = PlaylistLocation
		print(PlaylistsLocation[Playlist])
		CurrentDir = PlaylistLocation	
		GetSongs(PlaylistsLocation[Playlist])
		CurrentIDX = -1
		music_player.stop()
		print("Playlist selected")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	playing_now.visible = UsingPlayingNow
	currentSaveTime -= _delta
	if !BackroundSetup:
		if CurrentCustomBackroundImageDirectory != null and CurrentCustomBackroundImageDirectory != "":
			settings_menu_child._on_select_bg_dialog_file_selected(CurrentCustomBackroundImageDirectory)
			BackroundSetup = true
	if currentSaveTime < 0:
		currentSaveTime = SaveInterval
		if DiscordRichPresenceEnabled:
			DiscordUsername = DiscordRPC.get_current_user().get("username")
		if !LoadingSaveFailed:
			SaveEverything()
		@warning_ignore("integer_division")
		if DiscordRichPresenceEnabled:
			if DiscordRPC.large_image != "nullbody":
				UpdateSplashes()
			if DiscordRPC.get_is_discord_working():
				print(DiscordRPC.get_current_user()["username"])
			print(TimeSpentListening)
			var LText = SplashStrings.pick_random()
			if DiscordRPC.large_image != "nullbody":
				DiscordRPC.large_image_text = LText
			if DiscordRPC.get_is_discord_working():
				DiscordRPC.refresh()
	# "59:59 remaining" timestamp for the activity
	if music_player.playing:
		TimeSpentListening += _delta
		CurrentPausedIndicatorShaderIntensity = lerp(CurrentPausedIndicatorShaderIntensity,0.0,0.1)
		DiscordRPC.state = "Listening To Music"
	else:
		DiscordRPC.start_timestamp = int(0)
		DiscordRPC.state = "Paused"
		if DiscordRPC.get_is_discord_working():
			DiscordRPC.refresh()
		CurrentPausedIndicatorShaderIntensity = lerp(CurrentPausedIndicatorShaderIntensity,1.0,0.1)
	if DiscordRichPresenceEnabled:
		DiscordRPC.run_callbacks()
	var mat:ShaderMaterial = paused_indicator.material
	mat.set_shader_parameter("intensity",CurrentPausedIndicatorShaderIntensity)
	var CurrentLenght:float = music_player.get_playback_position() / CurrentSongLenth * current_progress.max_value
	if UpdateProgressSlider == true:
		current_progress.value = CurrentLenght
	#print(CurrentLenght)
	@warning_ignore("integer_division")
	var mins = int(music_player.get_playback_position()) / 60
	@warning_ignore("integer_division")
	var Hours:String = str(mins/60)
	if music_player.stream != null:
		var Minutes:String = (str("0" + str(mins%60)) if !int(music_player.stream.get_length() / 60) < 10 else str(mins%60)) if (mins%60) < 10 else str(mins%60)
		var Seconds:String = "0" + str(int(music_player.get_playback_position()) % 60) if int(music_player.get_playback_position()) % 60 < 10 else str(int(music_player.get_playback_position()) % 60)
		time_listening_song.text = Hours + ":" + Minutes + ":" + Seconds if int(music_player.stream.get_length() /60 / 60) != 0 else Minutes + ":" + Seconds
	else:
		time_listening_song.text = "0:00"
	
	#time_listening_song.text = str(music_player.get_playback_position())
	
	if Input.is_key_pressed(KEY_DOWN):
		volume_slider.value -= 1*_delta *50
	if Input.is_key_pressed(KEY_UP):
		volume_slider.value += 1*_delta *50
	
	if CurrentLenght == 0:
		if LoopingSong == false:
			CurrentIDX +=1
		PlaySongs()
		if ReactivateLoop:
			LoopingSong = true
			ReactivateLoop = false
			loop.icon = LoopPressed
		DiscordRPC.refresh()


func UpdateSplashes():
	if DiscordRPC.get_is_discord_working():
		SplashStrings = ["Total listening time: %s!" % str(str(int(TimeSpentListening/60)/60 )
			 + "h : " + str((int(TimeSpentListening) / 60) % 60) + "m : " + 
			str(int(TimeSpentListening) % 60) + "s"),
			"Version: %s" % version.text,"🤷‍♂️","This Changes every ~11 seconds",
			"hello everybody my name is %s" % DiscordRPC.get_current_user()["username"],
			"wash your dishes, i know you got some","Running on %s" % OS.get_distribution_name(),
			"%s is cooking" % DiscordRPC.get_current_user()["username"], "debugging" if OS.has_feature("editor") else "Release build",
			"this user chose to show you all this info","Playing a Banger",
			":steamhappy:","This is a sign that crocodiles live in water",
			"Space? SPACE?! SPAAAAAAAAAAAAACE!!!",
			"i love gd colonge",
			"listening with reverb" if settings_menu_child.reverb_check.button_pressed else
			"not listening with reverb","the cake is edible",
			"what a great song!","this message is useless",
			"stop reading these","why are you reading these",
			"hello from mars", "hello to mars","there is a fly in my room",
			"yippee!","What, are they allergic to bathtubs or something",
			"Did you know, a 737 can land with up to 33knots of wind!",
			"Welcome to todays JahresSchau",
			"ram is very useful","your cpu is tasty","main course: Nvidia GPU",
			"SCHOTTLAND FUER IMMER","i eat airborne vehicles","linus trovalds",
			"™","＼（〇_ｏ）／","Nuh Uh!","Yuh Huh","Breaching.",
			"I get a narcissistic injury when the wall ignores me","totally not using %s" % version.text] 


func SaveEverything():
	var Data:Dictionary = {
		"Version" : version.text,
		"Volume" : volume_slider.value,
		"Directory" : CurrentDir,
		"CurrIDX" : CurrentIDX,
		"Randomized" : Randomized,
		"Playing" : music_player.playing,
		"SeenWAVDisclaimer" : SeenWAVDisclaimer,
		"TimeSpentListening" : TimeSpentListening,
		"DiscordRichPresenceEnabled" : DiscordRichPresenceEnabled,
		"ReverbEnabled" : settings_menu_child.reverb_check.button_pressed,
		"ReverbRoomSize" : settings_menu_child.room_size_slider.value,
		"ReverbDampening" : settings_menu_child.dampening_size_slider.value,
		"ReverbSpread" : settings_menu_child.spread_size_slider.value,
		"CompressionEnabled" : settings_menu_child.compression_check.button_pressed,
		"CompressionThreshold" : settings_menu_child.threshold_slider.value ,
		"CompressionRatio" : settings_menu_child.ratio_slider.value ,
		"CompressionGain" : settings_menu_child.gain_slider.value,
		"CurrentCustomBackroundImageDirectory" : CurrentCustomBackroundImageDirectory,
		"PlayAllLists" : PlayAllLists,
		"DiscordUsername" : DiscordRPC.get_current_user().get("username"),
		"UsingPlayingNow" : UsingPlayingNow
	}
	print("saving")
	saveUserdata(Data)
	savePlaylists()

var saveRetrys:int =0

func savePlaylists():
	var json = JSON.new()
	var file = FileAccess.open("user://playlists.dat", FileAccess.WRITE)
	var file2 = FileAccess.open("user://playlistsLocation.dat", FileAccess.WRITE)
	@warning_ignore("static_called_on_instance")
	if !(Playlists == null) or !(Playlists == {}):
		file.store_string(str(json.stringify(Playlists)))
	if !(PlaylistsLocation == null) or !(PlaylistsLocation == {}):
		file2.store_string(str(json.stringify(PlaylistsLocation)))
	if loadUserdata() == {}:
		if saveRetrys < 3:
			savePlaylists()
		else:
			printerr("saving failed")


func saveUserdata(content):
	var json = JSON.new()
	var file = FileAccess.open("user://data.dat", FileAccess.WRITE)
	@warning_ignore("static_called_on_instance")
	file.store_string(json.stringify(content))
	file.close()

var saveLoadTries:int

func loadUserdata() -> Dictionary:
	var json = JSON.new()
	var file = FileAccess.open("user://data.dat", FileAccess.READ)
	var filetext = file.get_as_text() if file != null else null
	if file != null:
		var content:Dictionary = {}
		if json.parse_string(file.get_as_text()) != null:
			content = json.parse_string(filetext)
		else:
			@warning_ignore("static_called_on_instance")
			content = json.parse_string(Marshalls.base64_to_utf8(file.get_as_text()))
		file.close()
		if content != null:
			LoadingSaveFailed = false
			return content
		else:
			LoadingSaveFailed = true
			return {}
	else: 
		file.close()
		printerr("loading save failed")
		if saveLoadTries < 3:
			print("retrying")
			saveLoadTries +=1
			return loadUserdata()
		LoadingSaveFailed = true
		return {}


var playlistLoadTries:int
func loadPlaylists():
	var json = JSON.new()
	var file = FileAccess.open("user://playlistsLocation.dat", FileAccess.READ)
	var file2 = FileAccess.open("user://playlists.dat", FileAccess.READ)
	var filetext = file.get_as_text()
	print("Playlists")
	print(filetext)
	#print("shit " + json.parse_string(filetext))
	if file.get_as_text() != "" and file2.get_as_text() != "":
		var PlaylistsLocationTemp
		var PlaylistsTemp
		PlaylistsLocationTemp = json.parse_string(file.get_as_text())
		PlaylistsTemp = json.parse_string(file2.get_as_text())
		if (PlaylistsTemp == null) or (PlaylistsLocationTemp == null):
			printerr("Loading playlists failed")
			LoadingSaveFailed = true
		else:
			LoadingSaveFailed = false
			Playlists = PlaylistsTemp
			PlaylistsLocation = PlaylistsLocationTemp
		print(PlaylistsLocation)
		print(Playlists.keys())
		print("Playlists")
	file.close()
	file2.close() 
