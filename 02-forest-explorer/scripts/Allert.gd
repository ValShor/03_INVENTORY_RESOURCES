extends Area2D
const Target_Scene = "res://scenes/Forest.tscn"
const Player_Node_Name = "Player"
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == Player_Node_Name:
	get_tree().change_scene_to_file.call_deferred(Target_Scene)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
