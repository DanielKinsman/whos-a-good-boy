class_name Menu
extends Control


signal close_menu_requested()


@onready var close_menu_button: Button = $VBoxContainer/HBoxContainer/ButtonCloseMenu


func _ready() -> void:
    close_menu_button.pressed.connect(func() -> void: close_menu_requested.emit())
