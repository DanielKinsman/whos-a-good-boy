class_name WristUI
extends Container


signal menu_requested()


@onready var height_button: CheckButton = $MarginContainer/GContainer/HBoxContainer/CheckButton
@onready var height_label: Label = $MarginContainer/GContainer/HBoxContainer/HeightLabel
@onready var height_slider: Slider  = $MarginContainer/GContainer/HeightSlider
@onready var menu_button: Button = $MarginContainer/GContainer/HBoxContainer3/MenuButton
@onready var quit_button: Button = $MarginContainer/GContainer/HBoxContainer3/QuitButton


func _ready() -> void:
    quit_button.pressed.connect(func() -> void: get_tree().quit())
    menu_button.pressed.connect(func() -> void: menu_requested.emit())
    height_slider.value_changed.connect(height_changed)
    height_button.toggled.connect(override_height_toggled)


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
