extends Node3D


@onready var dog: Doggo = $Doggo
@onready var stick: Node3D = $Stick


func _ready() -> void:
    dog.target = stick
