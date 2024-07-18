class_name FloatingMenu
extends Node3D


@onready var original_transform := Transform3D(self.transform)
@onready var viewport: XRToolsViewport2DIn3D = $Viewport2Din3D
@onready var camera: XRCamera3D


func _ready() -> void:
    hide_menu()
    camera = get_parent() as XRCamera3D
    if not is_instance_valid(camera):
        camera = XRHelpers.get_xr_camera(self)


func hide_menu() -> void:
    self.hide()
    viewport.enabled = false


func show_menu() -> void:
    if not is_instance_valid(camera):
        push_error("No camera found for FloatingMenu")
        return

    var cam_forward := camera.global_transform * (Vector3.FORWARD * 3.0)
    cam_forward.y = camera.global_position.y
    self.look_at_from_position(cam_forward, camera.global_position)
    self.rotate_object_local(Vector3.UP, PI)
    viewport.enabled = true
    self.show()
