class_name Doggo
extends CharacterBody3D


signal has_picked_up(what: XRToolsPickable)
signal has_dropped()


const JUMP_VELOCITY := 4.5
const FRICTION := 5.0
const VELOCITY_TURNFACING_THRESHOLD := 1.0**2


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var walk_backwards := false


@onready var move_target: Node3D = null
@onready var orient_target: Node3D = null
@onready var look_target: Node3D = null

@onready var mouth_snap_zone: XRToolsSnapZone = $SnapZone


func _ready() -> void:
    mouth_snap_zone.has_picked_up.connect(self.picked_up)
    mouth_snap_zone.has_dropped.connect(self.dropped)
    mouth_snap_zone.enabled = false


func _physics_process(delta: float) -> void:
    # Gravity and friction applied here, everything else via behaviour tree
    if is_on_floor():
        velocity -= velocity * FRICTION * delta
    else:
        velocity.y -= gravity * delta

    orient()
    move_and_slide()


func picked_up(pickable: XRToolsPickable) -> void:
    self.has_picked_up.emit(pickable)
    mouth_snap_zone.enabled = false


func dropped() -> void:
    self.has_dropped.emit()


func orient() -> void:
    if is_instance_valid(orient_target):
        self.look_at(orient_target.global_position)
        # TODO lerp
        return

    # default to following movement
    if velocity.length_squared() < VELOCITY_TURNFACING_THRESHOLD:
        return

    var look := Vector3(velocity)
    if self.global_position.y < 0.5:  # TODO hax assumes floor is at 0y
        look.y = 0.0
        self.look_at(self.global_position + look)
        # TODO make it more natural when quick changes of direction (lerp)
