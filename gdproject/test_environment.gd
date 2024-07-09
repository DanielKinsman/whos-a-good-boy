class_name TestEnvironment
extends Node3D


@onready var dog: Doggo = $Doggo
@onready var stick: XRToolsPickable = $Stick
@onready var thrown_object: XRToolsPickable = null
@onready var human_front_pos := Node3D.new()


func _ready() -> void:
    dog.has_picked_up.connect(self.dog_picked_up)
    dog.has_dropped.connect(self.dog_dropped)
    stick.dropped.connect(self.pickable_dropped)

    get_viewport().get_camera_3d().add_child(human_front_pos)
    human_front_pos.position = Vector3.FORWARD * 2.0
    human_front_pos.global_position.y = 0.0  # TODO undo hax floor at 0ys

    thrown_object = stick  # TODO undo hax


func pickable_dropped(pickable: XRToolsPickable) -> void:
    if pickable.linear_velocity.length_squared() > 0.5:  # TODO fix magic number
        thrown_object = pickable


func dog_picked_up(what: XRToolsPickable) -> void:
    if thrown_object == what:
        thrown_object = null

    #if what == dog.target:
        #var cam: Camera3D = get_viewport().get_camera_3d()
        #pickup_return.global_position = cam.global_position + cam.global_basis * Vector3.FORWARD * 1.0
        #pickup_return.global_position.y = 0.0  # TODO undo hax assumes floor at 0y
        #dog.target = pickup_return


func dog_dropped() -> void:
    pass
    #var cam: Camera3D = get_viewport().get_camera_3d()
    #pickup_return.global_position = cam.global_position + cam.global_basis * Vector3.FORWARD * 3.0
    #pickup_return.global_position.y = 0.0  # TODO undo hax assumes floor at 0y
    #dog.target = pickup_return
    #dog.walk_backwards = true
