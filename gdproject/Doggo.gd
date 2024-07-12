class_name Doggo
extends CharacterBody3D


signal has_picked_up(what: XRToolsPickable)
signal has_dropped()


const JUMP_VELOCITY := 4.5
const FRICTION := 5.0
const VELOCITY_TURNFACING_THRESHOLD := 0.1**2
const ANIMATIONS := {
    &"run": &"for dog|for dog|standing_Run3_001"
}
const MOUTH_BONE := &"WOODEN STICK"


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
    #mouth_snap_zone.rotate_object_local(Vector3.FORWARD, PI/2.0)
    #mouth_snap_zone.translate_object_local(Vector3.LEFT * 0.07)
    #mouth_snap_zone.translate_object_local(Vector3.DOWN * 0.05)

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
    if is_instance_valid(orient_target):
        var look := Vector3(orient_target.global_position)
        look.y = self.global_position.y
        lerp_look_at(look, 0.1)
        return

    # default to following movement
    if velocity.length_squared() < VELOCITY_TURNFACING_THRESHOLD:
        return

    var y_clamp := Vector2(velocity.x, velocity.z).length() * 0.75
    if is_on_floor():
        y_clamp = 0.0

    lerp_look_at(
        self.global_position + Vector3(velocity.x, clampf(velocity.y * 0.5, -y_clamp, +y_clamp), velocity.z),
        0.1, # TODO make the lerp weight proportional to velocity magnitude
    )


func lerp_look_at(at: Vector3, weight: float) -> void:
        if at.is_equal_approx(self.global_position):
            return

        # this is so hacky but it works
        var old_trans := Transform3D(self.transform)
        self.look_at(at)
        var new_trans := Transform3D(self.transform)
        self.transform = old_trans.interpolate_with(new_trans, weight)
