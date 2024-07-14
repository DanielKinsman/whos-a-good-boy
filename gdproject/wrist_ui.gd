extends MarginContainer


signal hit_credits()


@onready var height_button: CheckButton = $GContainer/HBoxContainer/CheckButton
@onready var height_label: Label = $GContainer/HBoxContainer/HeightLabel
@onready var height_slider: Slider  = $GContainer/HeightSlider
@onready var quality_slider: Slider = $GContainer/HBoxContainer2/QualitySlider
@onready var fps_label: Label = $GContainer/HBoxContainer3/LabelFPS


func _ready() -> void:
    $GContainer/HBoxContainer3/QuitButton.connect("button_up", self.quit)
    $GContainer/HBoxContainer3/CreditsButton.connect("pressed", show_credits)
    height_slider.value_changed.connect(height_changed)
    height_button.toggled.connect(override_height_toggled)
    quality_slider.value_changed.connect(quality_changed)


func quit() -> void:
    get_tree().quit()


func _process(_delta: float) -> void:
    fps_label.text = "%0.1f fps" % Performance.get_monitor(Performance.TIME_FPS)


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


func quality_changed(value: float) -> void:
    var viewport: Viewport = XRHelpers.get_xr_origin(self).get_viewport()
    var quality: = int(value)
    match quality:
        0:
            viewport.vrs_mode = Viewport.VRS_XR
            viewport.msaa_3d = Viewport.MSAA_DISABLED
            viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
        1:
            viewport.vrs_mode = Viewport.VRS_XR
            viewport.msaa_3d = Viewport.MSAA_2X
            viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
        2:
            viewport.vrs_mode = Viewport.VRS_DISABLED
            viewport.msaa_3d = Viewport.MSAA_DISABLED
            viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA
        3:
            viewport.vrs_mode = Viewport.VRS_DISABLED
            viewport.msaa_3d = Viewport.MSAA_2X
            viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
        4:
            viewport.vrs_mode = Viewport.VRS_DISABLED
            viewport.msaa_3d = Viewport.MSAA_4X
            viewport.screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED

    print("VRS %s" % viewport.vrs_mode)
    print("MSAA %s" % viewport.msaa_3d)
    print("SSAA %s" % viewport.screen_space_aa)


func show_credits() -> void:
    # more hax
    var wrist_ui: Node3D = XRTools.find_xr_ancestor(self, "Viewport2Din3D")
    if not is_instance_valid(wrist_ui):
        return

    var credits: Node3D = wrist_ui.find_child("Credits3D")
    if not is_instance_valid(credits):
        return

    credits.visible = true
    credits.process_mode = Node.PROCESS_MODE_INHERIT
    await get_tree().create_timer(10.0).timeout
    credits.visible = false
    credits.process_mode = Node.PROCESS_MODE_DISABLED
