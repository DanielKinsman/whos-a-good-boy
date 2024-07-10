class_name TestEnvironment
extends Node3D


@onready var dog: Doggo = $Doggo
@onready var stick: XRToolsPickable = $Stick
@onready var thrown_object: XRToolsPickable = null
@onready var held_object : XRToolsPickable = null


func _ready() -> void:
    dog.has_picked_up.connect(self.dog_picked_up)
    stick.dropped.connect(self.pickable_dropped)
    stick.picked_up.connect(self.pickable_picked_up)


func pickable_dropped(pickable: XRToolsPickable) -> void:
    if held_object == pickable:
        held_object = null

        if pickable.linear_velocity.length_squared() > 0.5:  # TODO fix magic number
            thrown_object = pickable
            var sound :XRToolsPickableAudio = thrown_object.get_node("PickableAudio")
            if is_instance_valid(sound):
                # this is very hacky
                sound.stream = sound.pickable_audio_type.hit_sound
                sound.play()


func pickable_picked_up(pickable: XRToolsPickable) -> void:
    if pickable.get_picked_up_by() as XRToolsFunctionPickup != null:
        held_object = pickable  # only picked up by hands, not by snap zones (dog)

    var rumbler: XRToolsRumbler = pickable.get_node("XRToolsRumbler")  # hax
    if is_instance_valid(rumbler):
        rumbler.rumble_hand(pickable.get_picked_up_by_controller())


func dog_picked_up(what: XRToolsPickable) -> void:
    if thrown_object == what:
        thrown_object = null


func get_camera() -> Camera3D:
    var cam: Camera3D = XRHelpers.get_xr_camera(self)
    if is_instance_valid(cam):
        return cam

    return get_viewport().get_camera_3d()
