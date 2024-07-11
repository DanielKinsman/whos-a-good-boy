class_name Doggo
extends CharacterBody3D


signal has_picked_up(what: XRToolsPickable)
signal has_dropped()


const JUMP_VELOCITY := 4.5
const FRICTION := 5.0
const VELOCITY_TURNFACING_THRESHOLD := 1.0**2
const ANIMATIONS := {
    &"run": &"for dog|for dog|standing_Run3_001"
}
const MOUTH_BONE := &"L_mouth_corner_jnt.97_97"


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")


@onready var move_target: Node3D = null
@onready var orient_target: Node3D = null
@onready var look_target: Node3D = null

@onready var mouth_snap_zone: XRToolsSnapZone = $SnapZone
@onready var animation: AnimationTree = $AnimationTree
@onready var skeleton: Skeleton3D = $"run/for dog/Skeleton3D"
@onready var mouth_bone := skeleton.find_bone(MOUTH_BONE)


func _ready() -> void:
    mouth_snap_zone.has_picked_up.connect(self.picked_up)
    mouth_snap_zone.has_dropped.connect(self.dropped)
    mouth_snap_zone.enabled = false
    animation.active = true


func _physics_process(delta: float) -> void:
    # Gravity and friction applied here, everything else via behaviour tree
    if is_on_floor():
        velocity -= velocity * FRICTION * delta
    else:
        velocity.y -= gravity * delta

    orient()
    move_and_slide()
    animate()


func animate() -> void:
    mouth_snap_zone.global_transform = skeleton.global_transform * skeleton.get_bone_global_pose(mouth_bone)
    mouth_snap_zone.rotate_object_local(Vector3.FORWARD, PI/2.0)
    mouth_snap_zone.translate_object_local(Vector3.LEFT * 0.1)

    var speed := velocity.length()
    animation.set("parameters/TimeScaleRun/scale", max(0.01, speed) / 5.0)  # TODO remove magic numbers

    if is_on_floor():
        if speed > 1.0:
            animation.set("parameters/Transition/transition_request", "running")
        else:
            animation.set("parameters/Transition/transition_request", "idle")


func picked_up(pickable: XRToolsPickable) -> void:
    self.has_picked_up.emit(pickable)
    mouth_snap_zone.enabled = false


func dropped() -> void:
    self.has_dropped.emit()


func orient() -> void:
    var look: Vector3
    if is_instance_valid(orient_target):
        look = orient_target.global_position
        look.y = 0.0
        self.look_at(look)
        # TODO lerp
        return

    # default to following movement
    if velocity.length_squared() < VELOCITY_TURNFACING_THRESHOLD:
        return

    look = self.velocity
    if self.global_position.y < 0.5:  # TODO hax assumes floor is at 0y
        look.y = 0.0
        self.look_at(self.global_position + look)
        # TODO make it more natural when quick changes of direction (lerp)
