extends Control
@onready var Parent:MainScene = get_tree().root.get_child(2)
@onready var animation_player := $AnimationPlayer as AnimationPlayer
@onready var version: Label = $"../Version"

@onready var update_button := $Update as Button
@onready var http_request := $HTTPRequest as HTTPRequest
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
	OS.shell_open(updateLink)
