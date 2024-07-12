@tool
extends BTAction

const ACCELERATION := 20.0

@export_range(0.0, 100.0) var min_distance := 1.0
@export_range(0.0, 100.0) var max_distance := 10
var dog: Doggo


func _enter() -> void:
    dog = agent.get_node("Doggo")


func _tick(delta: float) -> Status:
    if not is_instance_valid(dog.move_target):
        return FAILURE

    var vector_to_target := dog.move_target.global_position - dog.global_position
    var distance_to_target := vector_to_target.length()
    if min_distance <= distance_to_target and distance_to_target <= max_distance:
        return SUCCESS

    if dog.is_on_floor():
        var ground_vector_to_target := Vector3(vector_to_target.x, 0.0, vector_to_target.z)
        if max_distance < distance_to_target:
            dog.velocity += ground_vector_to_target.normalized() * ACCELERATION * delta
        else:
            dog.velocity -= ground_vector_to_target.normalized() * ACCELERATION * delta

    return RUNNING
