@tool
extends RichTextLabel


func _ready() -> void:
    self.text = FileAccess.open("res://credits.md", FileAccess.READ).get_as_text()
