@tool
extends BTAction

const TARGET_THRESHOLD := 0.5**2
const ACCELERATION := 20.0


var dog: Doggo


func _enter() -> void:
    dog = agent.get_node("Doggo")


func _tick(delta: float) -> Status:
    if not is_instance_valid(dog.move_target):
        return FAILURE

    var vector_to_target := dog.move_target.global_position - dog.global_position
    var ground_vector_to_target := Vector3(vector_to_target.x, 0.0, vector_to_target.z)
    if ground_vector_to_target.length_squared() <= TARGET_THRESHOLD:
        return SUCCESS

    if dog.is_on_floor():
        dog.velocity += ground_vector_to_target.normalized() * ACCELERATION * delta
        # TODO jumping

    return RUNNING
