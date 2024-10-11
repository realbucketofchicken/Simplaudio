extends VBoxContainer

var HzDec = {0:"32 Hz",
			1:"100 Hz",
			2:"320 Hz",
			3:"1000 Hz",
			4:"3200 Hz",
			5:"10000 Hz"}

var gainValueLabels:Array = []
var gainValueSlider:Array = []
@onready var eq_check_box: CheckBox = $"../EQCheckBox"

@onready var EQA:AudioEffectEQ6 = AudioServer.get_bus_effect(AudioServer.get_bus_index("Music"),1)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for band in EQA.get_band_count():
		
		var slider:HSlider = HSlider.new()
		slider.min_value = -100
		slider.max_value = 20
		slider.custom_minimum_size = Vector2(200,0)
		slider.name = str(band)
		slider.value_changed.connect(valueChanged.bind(slider))
		
		var label:Label = Label.new()
		label.text = HzDec.get(band)
		
		var label2:Label = Label.new()
		label2.text = " 0 "
		
		var seperator:HSplitContainer = HSplitContainer.new()
		var seperator2:HSplitContainer = HSplitContainer.new()
		seperator.dragger_visibility = SplitContainer.DRAGGER_HIDDEN_COLLAPSED
		seperator2.dragger_visibility = SplitContainer.DRAGGER_HIDDEN_COLLAPSED
		add_child(seperator)
		seperator.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		
		seperator.split_offset = 200
		seperator.clamp_split_offset()
		
		seperator.add_child(slider)
		gainValueSlider.append(slider)
		
		seperator.add_child(seperator2)
		
		seperator2.add_child(label2)
		gainValueLabels.append(label2)
		seperator2.add_child(label)

func valueChanged(value,slider):
	var idx = slider.name.to_int()
	print(idx)
	print(gainValueLabels)
	EQA.set_band_gain_db(idx,value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	for band in EQA.get_band_count():
		gainValueLabels[band].text = str(" " + str(EQA.get_band_gain_db(band)) + " db ")


func _on_reset_pressed() -> void:
	for band in EQA.get_band_count():
		EQA.set_band_gain_db(band,0)
		gainValueSlider[band].value = 0
		eq_check_box.button_pressed = false
		gainValueLabels[band].text = str(" " + str(EQA.get_band_gain_db(band)) + " db ")
		
