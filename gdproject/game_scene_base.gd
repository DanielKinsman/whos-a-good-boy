@tool
extends XRToolsSceneBase

@onready var menu: FloatingMenu = $XROrigin3D/XRCamera3D/FloatingMenu
@onready var locomotion_ui: XRLocomotionOptionsUI
@onready var graphics_ui: XRGraphicsOptionsUI
@onready var wrist_ui_viewport: XRToolsViewport2DIn3D = $XROrigin3D/LeftHand/CollisionHandLeft/Viewport2Din3D
@onready var wrist_ui: WristUI = wrist_ui_viewport.scene_node
@onready var movement_direct: XRToolsMovementDirect = $XROrigin3D/LeftHand/CollisionHandLeft/MovementDirect
@onready var movement_teleport: XRToolsFunctionTeleport = $XROrigin3D/LeftHand/CollisionHandLeft/FunctionTeleport
@onready var movement_turn: XRToolsMovementTurn = $XROrigin3D/RightHand/CollisionHandRight/MovementTurn


func _ready() -> void:
    locomotion_ui = (menu.get_child(0) as XRToolsViewport2DIn3D).scene_node.find_child("XrLocomotionOptionsUI")
    graphics_ui = (menu.get_child(0) as XRToolsViewport2DIn3D).scene_node.find_child("XRGraphicsOptionsUI")

    wrist_ui.menu_requested.connect(func() -> void: menu.show_menu())
    locomotion_ui.movement_method_changed.connect(_on_movement_changed)
    locomotion_ui.strafe_changed.connect(_on_strafe_changed)
    locomotion_ui.turn_method_changed.connect(_on_turn_method_changed)


func _on_movement_changed(method: XRLocomotionOptionsUI.Movement) -> void:
    movement_direct.enabled = method == XRLocomotionOptionsUI.Movement.DIRECT
    movement_teleport.enabled = method == XRLocomotionOptionsUI.Movement.TELEPORT


func _on_strafe_changed(on: bool) -> void:
    movement_direct.strafe = on


func _on_turn_method_changed(method: XRLocomotionOptionsUI.Turn, snap_degrees: float) -> void:
    if method == XRLocomotionOptionsUI.Turn.SMOOTH:
        movement_turn.turn_mode = XRToolsMovementTurn.TurnMode.SMOOTH
    else:
        movement_turn.turn_mode = XRToolsMovementTurn.TurnMode.SNAP

    movement_turn.step_turn_angle = snap_degrees
