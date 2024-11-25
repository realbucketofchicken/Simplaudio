extends Control
@onready var Parent:MainScene = get_tree().root.get_child(3)
@onready var version: Label = $"../Version"

@onready var http_request := $HTTPRequest as HTTPRequest
@onready var download_request: HTTPRequest = $DownloadRequest
@onready var link_button: Button = $ColorRect/LinkButton
@onready var update_available_text: Label = $ColorRect/UpdateAvailableText
@onready var updating_notification: Control = $"../UpdatingNotification"
@onready var errorLabel: Label = $"../UpdatingNotification/Error"
@onready var updating_bg: ColorRect = $"../UpdatingBG"
@onready var paused_indicator: TextureRect = $"../PausedIndicator"
@onready var patchnotes: RichTextLabel = $ColorRect/Patchnotes
@onready var link_bttnbg: ColorRect = $ColorRect/LinkButton/LinkBTTNBG
@onready var patchnotes_bg: ColorRect = $ColorRect/Patchnotes/PatchnotesBG

@export var errorColor:Color
@export var IMPUpdateLinkColor:Color
@export var IMPUpdatePatchNotesColor:Color

var CheckForUpdates:bool = true

var updateLink:String

# The GitHub releases API only allows 60 unauthenticated requests per hour,
const UPDATE_THROTTLE = 600

func _ready() -> void:
	hide()
	if CheckForUpdates:
		check_for_updates()

func check_for_updates() -> void:
	print("! INFO: Checking for updates…")

	var error := http_request.request(
			"https://api.github.com/repos/notdraimdev/Simplaudio/releases/latest"
	)

	if error != OK:
		push_error("! a client error occurred")
		errorLabel.text = "a client error occurred"

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
	if result2.has("tag_name"):
		if result2["tag_name"] != version.text:
			update_available_text.text = result2["tag_name"] + " Is Out!"
			show()
			updateLink = result2["html_url"]
	if result2.has("body"):
		patchnotes.text = str(result2["body"])
		if patchnotes.text.contains("(!IT)"):
			patchnotes.text = patchnotes.text.erase(patchnotes.text.find("(!IT)"),7)
			print("importaint update detected")
			update_available_text.text = "(Important) " + result2["tag_name"] + " Is Out!"
			patchnotes_bg.color = IMPUpdatePatchNotesColor
			link_bttnbg.color = IMPUpdateLinkColor
			link_bttnbg.StandardColor = IMPUpdateLinkColor

func _on_close_buen_pressed() -> void:
	hide()


func _on_link_button_pressed() -> void:
	link_button.disabled = true
	link_button.text = "Updating..."
	updating_notification.show()
	updating_bg.show()
	paused_indicator.hide()
	var exepath:PackedStringArray = OS.get_executable_path().split("/")
	var path:String = GetLocalPath()
	print(OS.get_executable_path())
	if !OS.has_feature("editor"):
		download_request.download_file = path + "download.zip"
		var DownloadLink:String
		if OS.get_name() == "Windows":
			DownloadLink = "https://github.com/notdraimdev/Simplaudio/releases/latest/download/Windows.zip"
		elif OS.get_name() == "Linux":
			DownloadLink = "https://github.com/notdraimdev/Simplaudio/releases/latest/download/Linux.zip"
		if DownloadLink.is_empty() != true:
			var error = download_request.request(DownloadLink
			)
			if error != OK:
				print("! DOWNLOAD ERROR: " + str(error))
				errorLabel.text = "DOWNLOAD FAILED ERROR CODE: " + str(error)
				errorLabel.label_settings.font_color = errorColor
			else:
				errorLabel.text = "downloading..."
		else:
			push_error("OS NOT SUPPORTED, you should not get this error but you did, congrat!")
			OS.shell_open(updateLink)

func _on_download_request_completed(result: int, response_code: int, headers: PackedStringArray, body: PackedByteArray) -> void:
	if result != HTTPRequest.RESULT_SUCCESS:
		print("! Something went wrong server side: " + str(result))
		errorLabel.text = "DOWNLOAD FAILED ERROR CODE: " + str(result)
		errorLabel.label_settings.font_color = errorColor
		return
	else:
		errorLabel.text = "unzipping..."
		print("works as expected brotha")
		var unzipper:ZIPReader = ZIPReader.new() # sus
		unzipper.open(GetLocalPath()+"download.zip")
		var files:PackedStringArray = unzipper.get_files()
		for file in files:
			var actualfile = file.replace("Linux/","").replace("Windows/","").replace("Android/","")
			print("FILE: " + actualfile)
			var FileAcess:FileAccess = FileAccess.open(GetLocalPath() + actualfile,FileAccess.WRITE_READ)
			
			if FileAcess != null:
				var downloadedfile = unzipper.read_file(file)
				FileAcess.store_buffer(downloadedfile)
				print("FOUND FILE: " + GetLocalPath()+file)
			#FileAcess.store_string()
		unzipper.close()
		OS.shell_open(OS.get_executable_path())
		get_tree().root.close_requested.emit()
		get_tree().root.queue_free()

func GetLocalPath() -> String:
	var exepath:PackedStringArray = OS.get_executable_path().split("/")
	var path:String
	for sting in (exepath.size()-1):
		path += exepath[sting] + "/"
	return path
