extends Node3D


@onready var dog: Doggo = $Doggo
@onready var stick: XRToolsPickable = $Stick
@onready var pickup_return: Node3D = $PickupReturn


func _ready() -> void:
    dog.has_picked_up.connect(self.dog_picked_up)
    dog.has_dropped.connect(self.dog_dropped)
    stick.dropped.connect(self.stick_dropped)


func stick_dropped(pickable: XRToolsPickable) -> void:
    if pickable.linear_velocity.length_squared() > 0.5:  # TODO fix magic number
        pass #dog.target = pickable


func dog_picked_up(what: XRToolsPickable) -> void:
    print(what) # delme
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
