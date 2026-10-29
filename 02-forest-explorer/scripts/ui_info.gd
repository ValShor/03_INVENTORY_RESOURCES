extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_next_button_pressed() -> void:
	var entered_name = $VBoxContainer/Name/NameTextEdit.text
	Global.name_player = entered_name
	get_tree().change_scene_to_file.call_deferred("res://scenes/Forest.tscn");
