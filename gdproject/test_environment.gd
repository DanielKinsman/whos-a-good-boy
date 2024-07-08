extends Node3D


@onready var dog: Doggo = $Doggo
@onready var stick: XRToolsPickable = $Stick


func _ready() -> void:
    dog.target = null
    dog.has_picked_up.connect(self.dog_picked_up)
    stick.dropped.connect(self.stick_dropped)


func stick_dropped(pickable: XRToolsPickable) -> void:
    if pickable.linear_velocity.length_squared() > 0.5:  # TODO fix magic number
        dog.target = pickable


func dog_picked_up(what: XRToolsPickable) -> void:
    if what == dog.target:
        dog.target = get_viewport().get_camera_3d()
