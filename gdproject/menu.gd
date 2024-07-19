class_name Menu
extends Control


signal close_menu_requested()


@onready var close_menu_button: Button = $VBoxContainer/HBoxContainer/ButtonCloseMenu
@onready var loco_ui: XRLocomotionOptionsUI = $VBoxContainer/TabContainer/Controls/VBoxContainer/XrLocomotionOptionsUI
@onready var help_direct_move: TextureRect = $VBoxContainer/TabContainer/Controls/VBoxContainer/TextureRectDirectMove
@onready var help_teleport: TextureRect = $VBoxContainer/TabContainer/Controls/VBoxContainer/TextureRectTeleport


func _ready() -> void:
    close_menu_button.pressed.connect(func() -> void: close_menu_requested.emit())
    loco_ui.movement_method_changed.connect(_on_movement_changed)


func _on_movement_changed(method: XRLocomotionOptionsUI.Movement) -> void:
    help_direct_move.visible = method == XRLocomotionOptionsUI.Movement.DIRECT
    help_teleport.visible = method == XRLocomotionOptionsUI.Movement.TELEPORT
