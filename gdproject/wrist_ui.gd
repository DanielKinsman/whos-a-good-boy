extends MarginContainer

@onready var height_button: CheckButton = $GContainer/HBoxContainer/CheckButton
@onready var height_label: Label = $GContainer/HBoxContainer/HeightLabel
@onready var height_slider: Slider  = $GContainer/HeightSlider


func _ready() -> void:
    $GContainer/QuitButton.connect("button_up", self.quit)
    height_slider.value_changed.connect(height_changed)
    height_button.toggled.connect(override_height_toggled)


func quit() -> void:
    get_tree().quit()


func height_changed(value: float) -> void:
    height_label.text = "Override player height: %0.2f m" % value
    var body: XRToolsPlayerBody = XRHelpers.get_xr_origin(self).get_node("PlayerBody")
    body.override_player_height("doggo", value)


func override_height_toggled(on: bool) -> void:
    height_slider.editable = on
    if on:
        height_changed(height_slider.value)
    else:
        var body: XRToolsPlayerBody = XRHelpers.get_xr_origin(self).get_node("PlayerBody")
        body.override_player_height("doggo", -1.0)
