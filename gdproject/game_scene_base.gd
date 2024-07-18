@tool
extends XRToolsSceneBase

@onready var menu: FloatingMenu = $XROrigin3D/XRCamera3D/FloatingMenu
@onready var wrist_ui_viewport: XRToolsViewport2DIn3D = $XROrigin3D/LeftHand/CollisionHandLeft/Viewport2Din3D
@onready var wrist_ui: WristUI = wrist_ui_viewport.scene_node


func _ready() -> void:
    wrist_ui.menu_requested.connect(func() -> void: menu.show_menu())
