extends Control
@onready var Parent:MainScene = get_tree().root.get_child(2)
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var version: Label = $"../Version"

@onready var update_button := $Update as Button
@onready var http_request := $HTTPRequest as HTTPRequest
@onready var download_request: HTTPRequest = $DownloadRequest
@onready var link_button: Button = $ColorRect/LinkButton

var CheckForUpdates:bool = true

var updateLink:String

# Only update once every UPDATE_THROTTLE seconds at most
# The GitHub releases API only allows 60 unauthenticated requests per hour,
# so this value should be kept relatively high
const UPDATE_THROTTLE = 600


func _ready() -> void:

	if CheckForUpdates:
		check_for_updates()

func check_for_updates() -> void:
	print("! INFO: Checking for updates…")

	var error := http_request.request(
			"https://api.github.com/repos/notdraimdev/Simplaudio/releases/latest"
	)

	if error != OK:
		push_error("! a client error occurred")

func _on_http_request_completed(result: int, _response_code: int, _headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		# The request failed for any reason, abort
		push_error("! Couldn't check for updates")
		return
	else:
		print("! Update check successful")
	var json = JSON.new()
	var result2 = json.parse_string(str(body.get_string_from_utf8()))
	print("! AHHH  " + str(result2))
	if result2["tag_name"] != version.text:
		show()
		updateLink = result2["html_url"]

func _on_close_buen_pressed() -> void:
	hide()


func _on_link_button_pressed() -> void:
	var exepath:PackedStringArray = OS.get_executable_path().split("/")
	var path:String = GetLocalPath()
	print(OS.get_executable_path())
	if !OS.has_feature("editor"):
		if OS.get_name() == "Windows":
			download_request.download_file = path + "download.zip/"
			var error = download_request.request(
								"https://github.com/notdraimdev/Simplaudio/releases/latest/download/Windows.zip"
			)
			if error != OK:
				print("! DOWNLOAD ERROR: " + str(error))
		else:
			OS.shell_open(updateLink)

func _on_download_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print("! Something went wrong server side: " + str(result))
		return
	else:
		print("works as expected brotha")
		var unzipper:ZIPReader = ZIPReader.new() # sus
		
		unzipper.open(GetLocalPath()+"download.zip")
		var files:PackedStringArray = unzipper.get_files()
		for file in files:
			var FileAcess:FileAccess = FileAccess.open(GetLocalPath() + file,FileAccess.READ_WRITE)
			if FileAcess != null:
				var downloadedfile = unzipper.read_file(file)
				FileAcess.store_var(downloadedfile)
			get_tree().root.queue_free()
			#FileAcess.store_string()
		unzipper.close()

func GetLocalPath() -> String:
	var exepath:PackedStringArray = OS.get_executable_path().split("/")
	var path:String
	for sting in (exepath.size()-1):
		path += exepath[sting] + "/"
	return path
