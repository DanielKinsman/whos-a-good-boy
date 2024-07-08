class_name Doggo
extends CharacterBody3D


signal has_picked_up(what: XRToolsPickable)
signal has_dropped()


const JUMP_VELOCITY := 4.5
const FRICTION := 5.0
const ACCELERATION := 20.0
const VELOCITY_TURNFACING_THRESHOLD := 1.0**2
const TARGET_THRESHOLD := 0.5**2


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")
var walk_backwards := false

@onready var mouth_snap_zone: XRToolsSnapZone = $SnapZone
@onready var target: Node3D = null:
    set(value):
        target = value
        if target is XRToolsPickable:
            mouth_snap_zone.enabled = true


func _ready() -> void:
    mouth_snap_zone.has_picked_up.connect(self.picked_up)
    mouth_snap_zone.has_dropped.connect(self.dropped)


func _physics_process(delta: float) -> void:
    if not is_on_floor():
        velocity.y -= gravity * delta

    var vector_to_target : Vector3
    var ground_vector_to_target : Vector3
    var direction := Vector3.ZERO

    if target != null:
        vector_to_target = self.target.global_position - self.global_position
        ground_vector_to_target = Vector3(vector_to_target.x, 0.0, vector_to_target.z)
        if ground_vector_to_target.length_squared() > TARGET_THRESHOLD:
            direction = ground_vector_to_target.normalized()
        elif (not (target is XRToolsPickable)) and self.velocity.length_squared() <= 0.25:  # TODO magic number
            if mouth_snap_zone.picked_up_object != null:
                mouth_snap_zone.drop_object()
            else:
                walk_backwards = false  # TODO proper state management and behaviours


    if is_on_floor():
        # TODO undo magic numbers
        if ground_vector_to_target.length_squared() < 3.0 and vector_to_target.y > 0.5 and vector_to_target.y < 2.0:
            velocity.y = JUMP_VELOCITY

        velocity -= velocity * FRICTION * delta
        velocity += direction * ACCELERATION * delta

    move_and_slide()

    if velocity.length_squared() > VELOCITY_TURNFACING_THRESHOLD:
        var look_at := Vector3(velocity)
        if self.global_position.y < 0.5:  # TODO hax assumes floor is at 0y
            look_at.y = 0.0

        if walk_backwards:
            look_at = -look_at

        self.look_at(self.global_position + look_at)
        # TODO make it more natural when quick changes of direction (lerp)
    # else look at camera (slowly)
    # TODO after landing, lie flat even if not moving in xz


func picked_up(pickable: XRToolsPickable) -> void:
    self.has_picked_up.emit(pickable)
    mouth_snap_zone.enabled = false

func dropped() -> void:
    self.has_dropped.emit()
