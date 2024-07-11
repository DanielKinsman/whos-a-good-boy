@tool
extends BTAction

const ACCELERATION := 20.0

@export_range(0.0, 100.0) var tolerance := 0.25
var dog: Doggo


func _enter() -> void:
    dog = agent.get_node("Doggo")
    blackboard.set_var(&"jump_requested", false)

func _tick(delta: float) -> Status:
    if not is_instance_valid(dog.move_target):
        return FAILURE

    var vector_to_target := dog.move_target.global_position - dog.global_position
    if not dog.is_on_floor():
        blackboard.set_var(&"jump_requested", false)
        if vector_to_target.length() <= tolerance * 2.0:  # cheat in mid air
            return SUCCESS
        else:
            return RUNNING

    if vector_to_target.length() <= tolerance:
        return SUCCESS

    var ground_vector_to_target := Vector3(vector_to_target.x, 0.0, vector_to_target.z)

    # if direction to target is more up than across, and within ?m and ?m high and within ?m accross, jump
    # TODO proper air intercept calculations based on object's trajectory and our trajectory
    if (vector_to_target.max_axis_index() == Vector3.AXIS_Y and
            vector_to_target.y > 2.0 and vector_to_target.y < 4.0 and
            ground_vector_to_target.length() < 1.0):
        #dog.velocity.y = 3.5
        # dog jumps about 1/3 of a second in to the animation
        if blackboard.get_var(&"jump_requested"):
            return RUNNING

        blackboard.set_var(&"jump_requested", true)
        dog.get_tree().create_timer(0.33).timeout.connect(func() -> void: dog.velocity.y = 4.5)
        dog.animation.set("parameters/OneShotBark/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_ABORT)
        if not dog.animation.get("parameters/OneShotJump/active"):
            dog.animation.set("parameters/OneShotJump/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
    else:
        dog.velocity += ground_vector_to_target.normalized() * ACCELERATION * delta

    return RUNNING
