extends CharacterBody2D
var speed = 40
@export var anim: AnimatedSprite2D
func _physics_process(_delta):
	var input = Vector2(Input.get_action_strength('ui_right') - Input.get_action_strength('ui_left'), Input.get_action_strength('ui_down') - Input.get_action_strength('ui_up'))
	velocity = input.normalized() * speed
	# Сюда код ниже
	move_and_slide()

@export var hand: Sprite2D

func _unhandled_input(event):
	if event.is_action_pressed('use_tool'):
		if Global.inventory.size() > 0:
			var item = Global.inventory[0]
			if item.is_tool:
				hand.texture = item.icon
