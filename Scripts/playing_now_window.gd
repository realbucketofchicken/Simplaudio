extends Control

@export var ParentScene:MainScene
@export var SongImage:TextureRect
@export var SongNameLabel: RichTextLabel
@export var SongNameScroller:ScrollContainer
@export var SongAuthorScroller:ScrollContainer
@export var SongAuthorLabel: RichTextLabel
@onready var ParentWindow:Window = $".."
@export var update_tick:float = 0.1
@export var slider:HSlider
var ticktime:float
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ParentScene.SongChanged.connect(SongChanged)

func scroll(scroller:ScrollContainer,incriment:float):
	var scroll_h = scroller.get_h_scroll_bar().max_value - scroller.custom_minimum_size.x
	if scroll_h !=0:
		scroller.scroll_horizontal = wrapi(scroller.scroll_horizontal+incriment,0,\
										scroll_h)
		return scroller.scroll_horizontal == scroll_h-1 or scroller.scroll_horizontal == 0
	return false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ticktime -= delta
	ParentWindow.size = size 
	slider.value = ParentScene.current_progress.value
	if ticktime <= 0:
		ticktime = update_tick
		if scroll(SongNameScroller,1):
			ticktime = 2
		scroll(SongAuthorScroller,1)

func SongChanged():
	SongImage.texture = ParentScene.cover.texture
	print("SongChanged: ", ParentScene.currentSongName)
	SongNameLabel.text = ParentScene.currentSongName
	if ParentScene.currentArtistName:
		SongAuthorLabel.text = ParentScene.currentArtistName
	else:
		SongAuthorLabel.text = ""
	#ParentWindow.size = size * 2
