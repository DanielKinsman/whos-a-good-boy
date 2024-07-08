extends CharacterBody3D


const JUMP_VELOCITY := 4.5
const FRICTION := 5.0
const ACCELERATION := 20.0
const VELOCITY_TURNFACING_THRESHOLD := 1.0**2


var gravity: float = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var dolly: CollisionShape3D = $CollisionShape3D
@onready var dolly_original_xform := Transform3D(dolly.transform)


func _physics_process(delta: float) -> void:
    # Add the gravity.
    if not is_on_floor():
        velocity.y -= gravity * delta

    # Handle jump.
    if Input.is_action_just_pressed("ui_accept") and is_on_floor():
        velocity.y = JUMP_VELOCITY

    # Get the input direction and handle the movement/deceleration.
    # As good practice, you should replace UI actions with custom gameplay actions.
    var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

    if is_on_floor():
        velocity -= velocity * FRICTION * delta
        velocity += direction * ACCELERATION * delta

    move_and_slide()
    if velocity.length_squared() > VELOCITY_TURNFACING_THRESHOLD:
        dolly.look_at(self.global_position + velocity)
        dolly.transform *= dolly_original_xform
        # TODO make it more natural when quick changes of direction (lerp)
    # else look at camera (slowly)
    # TODO after landing, lie flat even if not moving in xz
