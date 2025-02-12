class_name TestEnvironment
extends Node3D

const MOBILE_ENVIRONMENT := preload("res://environment_mobile.tres")

@onready var dog: Doggo = $Doggo
@onready var sticks: Node3D = $Sticks
@onready var thrown_object: XRToolsPickable = null
@onready var held_objects: Array[XRToolsPickable] = []
@onready var sun: DirectionalLight3D = $DirectionalLight3D
@onready var environment: WorldEnvironment = $WorldEnvironment


func _ready() -> void:
    if OS.get_name() == "Android":
        sun.light_energy = 0.25  # try to match the lighting from mobile renderer in glcompat renderer
        environment.environment = MOBILE_ENVIRONMENT

    dog.has_picked_up.connect(self.dog_picked_up)
    for s: XRToolsPickable in sticks.get_children():
        s.dropped.connect(self.pickable_dropped)
        s.picked_up.connect(self.pickable_picked_up)


func pickable_dropped(pickable: XRToolsPickable) -> void:
    if held_objects.has(pickable):
        held_objects.erase(pickable)

        if pickable.linear_velocity.length_squared() > 0.5:  # TODO fix magic number
            thrown_object = pickable
            var sound :XRToolsPickableAudio = thrown_object.get_node("PickableAudio")
            if is_instance_valid(sound):
                # this is very hacky
                sound.stream = sound.pickable_audio_type.hit_sound
                sound.play()


func pickable_picked_up(pickable: XRToolsPickable) -> void:
    if pickable.get_picked_up_by() as XRToolsFunctionPickup == null:
        return  # not picked up by player hands

    if not held_objects.has(pickable):
        held_objects.append(pickable)

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
